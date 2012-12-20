module DNU
  module Fight
    module State
      class MP < BaseValue
        
        def status
          self
        end
        
        def equip
          self
        end
        
        def min_val(n)
          0
        end
        
        def max_val(n)
          MMP.new(n, self)
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
