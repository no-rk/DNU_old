module DNU
  module Fight
    module State
      class BaseValue < SimpleDelegator
        attr_reader :ini, :val, :min, :max, :history
        
        def status
          self
        end
        
        def equip
          self
        end
        
        def next
          @next.last
        end
        
        def next!
          @next.pop
        end
        
        def status_next
          @next.last
        end
        
        def status_next!
          @next.pop
        end
        
        def status_next=(val)
          @next = [val]
        end
        
        def equip_next
          @next.last
        end
        
        def equip_next!
          @next.pop
        end
        
        def equip_next=(val)
          @next = [val]
        end
        
        def larger_of(a,b)
          a > b ? a : b
        end
        
        def min_val(n)
          larger_of(n/4, 50)
        end
        
        def max_val(n)
          larger_of(n*4, 200)
        end
        
        def set_min_max
          @min = min_val(val)
          @max = max_val(val)
          @validate = true
          set_val
          @ini = val
        end
        
        def initialize(n, parent = nil)
          @parent = parent
          @val = n.to_i
          @history = [val]
          @next = []
          super val
        end
        
        def validate_value
          if @validate.present?
            @val = min if @val < min
            @val = max if @val > max
            @val = @val.to_i
          end
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
        
        def ratio
          max==0 ? 0 : val.to_f/max.to_f
        end
        
        def change_value(n)
          @val += n
          set_val
        end
        
        def change_to(n)
          @val = n
          set_val
        end
        
      end
    end
  end
end
