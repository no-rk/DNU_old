module DNU
  module Fight
    module State
      class Cost < BaseValue
        
        def min_val(n)
          0
        end
        
        def max_val(n)
          10**10
        end
        
      end
    end
  end
end
