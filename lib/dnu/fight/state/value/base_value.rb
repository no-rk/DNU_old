module DNU
  module Fight
    module State
      class BaseValue < SimpleDelegator
        attr_reader :ini, :min, :max, :history
       
        def initialize(parent = nil, initial_value = 0)
          @parent        = parent
          @current_value = initial_value.to_i
          @history       = []
          @next_value    = []
          sync_value
        end
        
        def start(min_val = nil, max_val = nil)
          @min = self.class.new(self, min_val || min_cal(@current_value))
          @max = self.class.new(self, max_val || max_cal(@current_value))
          @validate = true
          sync_value
          @ini = Marshal.load(Marshal.dump(self))
        end
        
        def change_value(n)
          @current_value = (@current_value + n).to_i
          sync_value
        end
        
        def change_to(n)
          @current_value = n.to_i
          sync_value
        end
         
        def next_value=(n)
          @next_value = [n]
        end
         
        def next_value
          @next_value.last
        end
         
        def next_value!
          @next_value.pop
        end
        
        def val
          (next_value || @current_value).to_i
        end
        
        def val!
          (next_value! || @current_value).to_i
        end
        
        def ratio
          max.to_f==0 ? 0 : val.to_f/max.to_f
        end
        
        private
        def sync_value
          if @validate.present?
            validate_value
          end
          __setobj__ @current_value
          @parent.send(:sync_value) if @parent.present?
          if @validate.present?
            record_history
          end
        end
        
        def validate_value
          @current_value = min if @current_value < min
          @current_value = max if @current_value > max
          @current_value = @current_value.to_i
        end
        
        def record_history
          @history << Marshal.load(Marshal.dump(self)).send(:clear_history)
        end
        
        def clear_history
          @history = []
          self
        end
        
        def larger_of(a,b)
          a > b ? a : b
        end
        
        def min_cal(n)
          larger_of(n/4, 50)
        end
        
        def max_cal(n)
          larger_of(n*4, 200)
        end
      end
    end
  end
end
