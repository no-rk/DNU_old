# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Heal < BaseScene
        include Calculate
        
        def when_initialize
          @change = nil
        end
        
        def create_change
          @change ||= lambda{ calcu_value(@tree[:change_value]).call.to_i }
        end
        
        def play_children
          status_name     = @tree[:status_name]
          change          = (@change || create_change).call
          
          before_change = 対象.send(status_name).val
          対象.send(status_name).change_value(change)
          after_change  = 対象.send(status_name).val
          
          history[:children] = { :status_name => status_name, :change => change, :before_change => before_change, :after_change => after_change }
        end
        
        def play_before
        end
        
        def play_after
        end
        
      end
    end
  end
end
