# encoding: UTF-8
module DNU
  module Fight
    module State
      class BaseCharacter
        
        @@status_name = [:HP, :MP, :AT, :MAT, :DF, :MDF, :HIT, :MHIT, :EVA, :MEVA, :SPD]
        @@has_max     = [:HP, :MP]
        
        attr_accessor :name, :team
        attr_accessor :dead, :turn_end
        
        attr_reader *@@status_name
        attr_reader *@@has_max.inject([]){ |a,s| a<<('M'+s.to_s).to_sym }
        
        def initialize
          @@status_name.each do |stat|
            instance_variable_set("@#{stat}", "DNU::Fight::State::#{stat}".constantize.new(rand(500), rand(500)))
          end
          @@has_max.each do |stat|
            instance_variable_set("@M#{stat}", instance_variable_get("@#{stat}").max)
          end
        end
        
        def disease(type)
          rand(5)
        end
        
      end
    end
  end
end
