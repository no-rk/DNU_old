module DNU
  module Fight
    module State
      class BaseCharacter
        attr_accessor :name, :dead, :turn_end, :team, :HP, :MP, :AT, :MAT, :DF, :MDF, :HIT, :MHIT, :ENA, :MEVA, :SPD
        def initialize
          @HP = HP.new(1000)
        end
      end
    end
  end
end
