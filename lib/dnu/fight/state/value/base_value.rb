module DNU
  module Fight
    module State
      class BaseValue < SimpleDelegator
        attr_reader :ini, :val, :min, :max
        
        def min_val(n)
          n/5
        end
        
        def max_val(n)
          n*5
        end
        
        def initialize(n, parent = nil)
          @parent = parent
          @ini = n
          @val = n
          @min = min_val(n)
          @max = max_val(n)
          super val
        end
        
        def validate_value
          @val = @min if @val < @min
          @val = @max if @val > @max
          @val.to_i
        end
        
        def set_val
          validate_value
          __setobj__ val
          @parent.nil? ? val : @parent.send(:set_val)
        end
        
        def change_value(n)
          @val += n
          set_val
        end
        
      end
    end
  end
end
