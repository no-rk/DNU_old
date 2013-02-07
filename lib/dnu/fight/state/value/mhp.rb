module DNU
  module Fight
    module State
      class MHP < BaseValue
        
        def min_val(n)
          larger_of(n/4, 300)
        end
        
        def max_val(n)
          larger_of(n*4, 1200)
        end
        
      end
    end
  end
end
