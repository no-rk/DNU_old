# encoding: UTF-8
module DNU
  module Fight
    module State
      class BaseCharacter
        @@req_attri = [:MHP, :MMP, :HP, :MP, :AT, :MAT, :DF, :MDF, :HIT, :MHIT, :EVA, :MEVA, :SPD]
        
        attr_accessor :name, :dead, :turn_end, :team
        attr_reader *@@req_attri
        def initialize
          @@req_attri.each do |stat|
            eval "@#{stat} = #{stat}.new(rand(1000), rand(1000))"
          end
        end
        
        def disease(type)
          rand(5)
        end
      end
    end
  end
end
