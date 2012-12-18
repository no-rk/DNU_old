module DNU
  module Fight
    module State
      class BaseCharacter
        attr_accessor :name, :dead, :turn_end, :team, :MHP, :MMP, :HP, :MP, :AT, :MAT, :DF, :MDF, :HIT, :MHIT, :EVA, :MEVA, :SPD
        def initialize
          temp = 1000+rand(1000)
          @MHP = MHP.new(temp)
          @HP  = HP.new(rand(temp+1))
          temp = 1000+rand(1000)
          @MMP = MMP.new(temp)
          @MP  = MP.new(rand(temp+1))
          
          [:AT, :MAT, :DF, :MDF, :HIT, :MHIT, :EVA, :MEVA, :SPD].each do |stat|
            eval "@#{stat} = #{stat}.new(rand(1000))"
          end
        end
        
        def disease(type)
          rand(5)
        end
      end
    end
  end
end
