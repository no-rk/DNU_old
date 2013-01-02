# encoding: UTF-8
module DNU
  module Fight
    module State
      class BaseCharacter
        
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

        attr_accessor :name, :team
        attr_accessor :dead, :turn_end
        
        attr_reader *@@status_name
        attr_reader *@@disease_name
        attr_reader *@@has_max.inject([]){ |a,s| a<<('M'+s.to_s).to_sym }
        
        attr_reader :effects
        
        def initialize
          @@status_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(500+rand(50), 500+rand(50)))
          end
          @@has_max.each do |stat|
            instance_variable_set("@M#{stat}", instance_variable_get("@#{stat}").max)
          end
          @@disease_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(0, 0))
          end
          @effects = [].extend FindEffects
        end
        
        def live
          !@dead
        end
        
      end
    end
  end
end
