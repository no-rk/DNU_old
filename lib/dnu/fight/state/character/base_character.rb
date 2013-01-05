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
          tree[:settings].try(:each) do |setting|
            effects_type = setting.keys.first
            effects_name = setting[effects_type][:name]
            effects = tree[:definitions].try(:find){|d| d.keys.first==effects_type and d[effects_type][:name] == effects_name }
            raise "[#{I18n.t(effects_type.to_s.camelize, :scope => "DNU.Fight.Scene")}]#{effects_name}は定義されてない" if effects.nil?
            effects = effects[effects_type].merge(setting[effects_type])#.merge({:target=>{:find_by_position=>3}})
            es = "DNU::Fight::State::#{effects_type.to_s.camelize}".constantize.new(effects)
            es.each do |e|
              @effects << e
            end
          end
        end
        
        def live
          !@dead
        end
        
        def remove_effects(array)
          @effects = (@effects - array).extend FindEffects
          @effects_removed += array
          array.present?
        end
        
      end
    end
  end
end
