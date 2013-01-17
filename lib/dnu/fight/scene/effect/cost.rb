# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Cost < BaseEffect
        include Calculate
        
        def when_initialize
          @change = nil
        end
        
        def create_change
          @change ||= lambda{ calcu_value(@tree[:change_value]).call.to_i }
        end
        
        def play_children
          change =-(@change || create_change).call
          
          before_change = 対象.MP.val
          対象.MP.change_value(change)
          after_change  = 対象.MP.val
          
          history[:children] = { :before_change => before_change, :after_change => after_change }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
