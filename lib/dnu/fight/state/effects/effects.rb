module DNU
  module Fight
    module State
      class Effects < SimpleDelegator
        
        attr_reader :timing, :before_after, :priority, :condition, :do, :done
        
        def initialize(tree)
          super tree[:parent]
          @timing       = child_name(tree[:timing])
          @before_after = child_name(tree[:before_after])
          @priority     = tree[:priority].to_i
          @condition    = tree[:condition]
          @do           = tree[:do]
        end
        
        def on
          @done = nil
        end
        
        def off
          @done = true
        end
        
      end
    end
  end
end
