module DNU
  module Fight
    module State
      class MP < BaseValue
        
        def min_val(n)
          0
        end
        
        def max_val(n)
          MMP.new(n, self)
        end
        
        def set_min_max
          @min = min_val(val)
          @max.set_min_max
          @validate = true
          validate_value
          @ini = val
        end
        
        def initialize(status_val, equip_val)
          mix = status_val + equip_val
          @val = mix
          @max = max_val(val)
          super val
        end
        
      end
    end
  end
end
