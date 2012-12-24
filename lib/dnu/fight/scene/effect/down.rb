# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Down < BaseScene
        include Change
        
        def when_initialize
          @change = nil
        end
        
        def create_change
          @change ||= change_value(@tree[:change_value])
        end
        
        def play_children
          status_name     = @tree[:status_name]
          status_or_equip = @tree[:equip].nil? ? :status : :equip
          change          =-(@change || create_change).call
          
          before_change = 対象.send(status_name).send(status_or_equip).val
          対象.send(status_name).send(status_or_equip).change_value(change)
          after_change  = 対象.send(status_name).send(status_or_equip).val
          
          history[:children] = { :status_name => status_name, :before_change => before_change, :after_change => after_change }
        end
        
        def play_before
        end
        
        def play_after
        end
        
      end
    end
  end
end
