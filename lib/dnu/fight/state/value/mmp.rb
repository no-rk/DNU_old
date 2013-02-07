module DNU
  module Fight
    module State
      class MMP < BaseValue
        
        def min_val(n)
          larger_of(n/4, 150)
        end
        
        def max_val(n)
          larger_of(n*4, 600)
        end
        
      end
    end
  end
end
