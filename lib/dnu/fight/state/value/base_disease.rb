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
          @ini = mix
          @val = mix
          @min = min_val(mix)
          @max = max_val(mix)
          super val
        end
        
      end
    end
  end
end
