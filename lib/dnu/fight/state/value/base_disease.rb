module DNU
  module Fight
    module State
      class BaseDisease < BaseValue
        
        def min_val(n)
          0
        end
        
        def max_val(n)
          20
        end
        
        def initialize(status_val, equip_val)
          mix = status_val + equip_val
          super mix
        end
        
      end
    end
  end
end
