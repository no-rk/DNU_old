module DNU
  module Fight
    module State
      class TurnPriority < BaseValue
        
        def min_val(n)
          -10
        end
        
        def max_val(n)
          10
        end
        
      end
    end
  end
end
