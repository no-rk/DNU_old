# encoding: UTF-8
module DNU
  module Fight
    module State
      class Character
        
        @@id = 0
        
        @@status_name  = [:HP, :MP, :AT, :MAT, :DF, :MDF, :HIT, :MHIT, :EVA, :MEVA, :SPD, :CRI,
                          :FireValue, :FireResist, :WaterValue, :WaterResist,
                          :WindValue, :WindResist, :EarthValue, :EarthResist,
                          :LightValue, :LightResist, :DarkValue, :DarkResist,
                          :PoisonValue, :PoisonResist, :WetValue, :WetResist,
                          :SleepValue, :SleepResist, :BurnValue, :BurnResist,
                          :ShineValue, :ShineResist, :PalsyValue, :PalsyResist,
                          :VacuumValue, :VacuumResist, :MudValue, :MudResist,
                          :ConfuseValue, :ConfuseResist, :BlackValue, :BlackResist]
        @@has_max      = [:HP, :MP]
        @@disease_name = [:Poison, :Wet, :Sleep, :Burn, :Shine,
                          :Palsy, :Vacuum, :Mud, :Confuse, :Black]
        @@status_init  = [:Position, :TurnPriority, :ActCount, :Range]
        @@nexts        = [:target_set, :target, :hitrate, :attack_element, :attack_type, :attack_target, :turn, :act, :add_act,
                          :hit_val, :add_val, :heal_val, :convert_val, :cost_val, :rob_val, :steal_val,
                          :increase_val, :decrease_val, :up_val, :down_val, :reduce_val]
        
        attr_accessor :id, :name, :team, :parent, :parent_effect, :double, :dead, :turn_end
        
        attr_reader *@@status_name
        attr_reader *@@disease_name
        attr_reader *@@has_max.inject([]){ |a,s| a<<('M'+s.to_s).to_sym }
        attr_reader *@@status_init
        
        attr_reader :effects
        
        def initialize(tree)
          @@status_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(0, 0))
          end
          @@has_max.each do |stat|
            instance_variable_set("@M#{stat}", instance_variable_get("@#{stat}").max)
          end
          @@disease_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(0, 0))
          end
          @id   = @@id += 1
          @parent        = tree[:parent]
          @parent_effect = tree[:parent_effect]
          @name = tree[:name].to_s
          @team = tree[:team]
          @Position = DNU::Fight::State::Position.new(rand(3)+1)
          @TurnPriority = DNU::Fight::State::TurnPriority.new(0)
          @ActCount = DNU::Fight::State::ActCount.new(0)
          @effects         = [].extend FindEffects
          @effects_removed = [].extend FindEffects
          @@nexts.each do |n|
            ['', '_ant'].each do |ant|
              instance_variable_set("@next_#{n}#{ant}", [])
            end
          end
          tree[:settings].try(:each) do |setting|
            add_effects(setting.keys.first, setting.values.first[:name], setting.values.first, tree[:definitions], self)
          end
          # 武器なかったら素手にする処理をここに入れる if effects.type(:Weapon).blank?
          @Range = DNU::Fight::State::Range.new(effects.type(:Weapon).first.try(:range) || 1) # 射程は武器に依存
          add_disease
        end
        
        def set_min_max
          @@status_name.each do |stat|
            instance_variable_get("@#{stat}").set_min_max
          end
          @@disease_name.each do |stat|
            instance_variable_get("@#{stat}").set_min_max
          end
          @@status_init.each do |stat|
            instance_variable_get("@#{stat}").set_min_max
          end
        end
        
        def kind
          self.class.name.split("::").last.to_sym
        end
        
        def live
          !@dead
        end
        
        def add_effects(type, name, setting, definitions, parent_obj=nil)
          effects = definitions.try(:find){|d| d.keys.first==type and d[type][:name] == name }
          # 定義されていない場合はデータベースから読み込みを試みる
          if effects.nil?
            tree = "GameData::#{type.to_s.camelize}".constantize.select(:definition).find_by_name(name.to_s)
            if tree.present?
              parser    = EffectParser.new
              transform = EffectTransform.new
              tree = parser.send("#{type}_definition").parse(tree.definition)
              effects = { type => transform.apply(tree) }
            end
          end
          raise "[#{I18n.t(type.to_s.camelize, :scope => 'DNU.Fight.Scene')}]#{name}は定義されてない" if effects.nil?
          effects = effects[type].merge(setting).merge(:parent => parent_obj)
          es = "DNU::Fight::State::#{type.to_s.camelize}".constantize.new(effects)
          es.each do |e|
            @effects << e
          end
        end
        
        def remove_effects(array)
          @effects = (@effects - array).extend FindEffects
          @effects_removed += array
          array.present?
        end
        
        @@nexts.each do |n|
          ['', '_ant'].each do |ant|
            define_method("next_#{n}#{ant}!") do
              instance_variable_get("@next_#{n}#{ant}").pop
            end
            
            define_method("next_#{n}#{ant}") do
              instance_variable_get("@next_#{n}#{ant}").last
            end
            
            define_method("next_#{n}#{ant}=") do |la|
              instance_variable_set("@next_#{n}#{ant}", [la])
            end
            
            define_method("next_#{n}#{ant}?") do
              instance_variable_get("@next_#{n}#{ant}").present?
            end
          end
        end
        
        def build_double
          double = Marshal.load(Marshal.dump(self))
          double.id = @@id += 1
          double
        end
        
        private
        
        def add_disease
           GameData::Disease.pluck(:name).each do |name|
            add_effects(:disease, name, {}, {}, parent=nil)
           end
        end
        
      end
    end
  end
end
