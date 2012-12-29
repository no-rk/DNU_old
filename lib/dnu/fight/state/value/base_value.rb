module DNU
  module Fight
    module State
      class BaseValue < SimpleDelegator
        attr_reader :ini, :val, :min, :max, :history
        
        def min_val(n)
          n/5
        end
        
        def max_val(n)
          n*5
        end
        
        def initialize(n, parent = nil)
          @parent = parent
          @val = n.to_i
          @min = min_val(val)
          @max = max_val(val)
          validate_value
          @ini = val
          @history = [val]
          super val
        end
        
        def validate_value
          @val = @min if @val < @min
          @val = @max if @val > @max
          @val = @val.to_i
        end
        
        def history_value
          @history << val
        end
        
        def set_val
          validate_value
          history_value
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
