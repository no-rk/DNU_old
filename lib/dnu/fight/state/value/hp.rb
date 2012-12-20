module DNU
  module Fight
    module State
      class HP < BaseValue
        
        def status
          self
        end
        
        def equip
          self
        end
        
        def min_val(n)
          -10**10
        end
        
        def max_val(n)
          MHP.new(n, self)
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
