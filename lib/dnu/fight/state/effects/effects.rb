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
        
        def condition=(c)
          case type
          # 技の場合は消費による条件も追加
          when :Skill
            @condition = {
              :condition_and => [
                {
                  :condition_ge => {
                    :left  => { :state_character => { :state_target=> "自分", :status_name=> "MP" } },
                    :right => { :fixnum => cost }
                  }
                },
                c
              ]
            }
          else
            @condition = c
          end
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
