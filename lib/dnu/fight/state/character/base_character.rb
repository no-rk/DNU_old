# encoding: UTF-8
module DNU
  module Fight
    module State
      class BaseCharacter
        
        @@id = 0
        
        @@status_name = [:HP, :MP, :AT, :MAT, :DF, :MDF, :HIT, :MHIT, :EVA, :MEVA, :SPD,
                         :FireValue, :FireResist, :WaterValue, :WaterResist,
                         :WindValue, :WindResist, :EarthValue, :EarthResist,
                         :LightValue, :LightResist, :DarkValue, :DarkResist,
                         :PoisonValue, :PoisonResist, :WetValue, :WetResist,
                         :SleepValue, :SleepResist, :BurnValue, :BurnResist,
                         :ShineValue, :ShineResist, :PalsyValue, :PalsyResist,
                         :VacuumValue, :VacuumResist, :MudValue, :MudResist,
                         :ConfuseValue, :ConfuseResist, :BlackValue, :BlackResist]
        @@has_max     = [:HP, :MP]
        @@disease_name = [:Poison, :Wet, :Sleep, :Burn, :Shine,
                          :Palsy, :Vacuum, :Mud, :Confuse, :Black]

        attr_reader :name, :team, :id
        attr_accessor :dead, :turn_end
        
        attr_reader *@@status_name
        attr_reader *@@disease_name
        attr_reader *@@has_max.inject([]){ |a,s| a<<('M'+s.to_s).to_sym }
        
        attr_reader :Position, :Range, :effects
        
        def initialize(tree)
          @@status_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(450+rand(100), 450+rand(100)))
          end
          @@has_max.each do |stat|
            instance_variable_set("@M#{stat}", instance_variable_get("@#{stat}").max)
          end
          @@disease_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(0, 0))
          end
          @id   = @@id += 1
          @name = tree[:name].to_s
          @team = tree[:team]
          @Position = DNU::Fight::State::Position.new(rand(3)+1)
          @Range    = DNU::Fight::State::Range.new(rand(5)+1)
          @effects         = [].extend FindEffects
          @effects_removed = [].extend FindEffects
          @scope = []
          tree[:settings].try(:each) do |setting|
            add_effects(setting.keys.first, setting.values.first[:name], setting.values.first, tree[:definitions])
          end
        end
        
        def live
          !@dead
        end
        
        def add_effects(type, name, setting, definitions, parent=nil)
          effects = definitions.try(:find){|d| d.keys.first==type and d[type][:name] == name }
          # 定義されていない場合はデータベースから読み込みを試みる
          if effects.nil?
            parser    = EffectParser.new
            transform = EffectTransform.new
            tree = "GameData::#{type.to_s.camelize}".constantize.select(:definition).find_by_name(name.to_s)
            if tree.present?
              tree = parser.send("#{type}_definition").parse(tree.definition)
              effects = { type => transform.apply(tree) }
            end
          end
          raise "[#{I18n.t(type.to_s.camelize, :scope => 'DNU.Fight.Scene')}]#{name}は定義されてない" if effects.nil?
          effects = effects[type].merge(setting).merge(:parent => parent)
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
        
        def scope
          @scope.pop
        end
        
        def scope=(s)
          @scope.push(s.to_s)
        end
        
      end
    end
  end
end
