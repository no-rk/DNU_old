# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Heal < BaseEffect
        include Calculate
        
        def when_initialize
          @resilience = nil
        end
        
        def create_resilience
          @resilience ||= lambda{ calcu_value(@tree[:change_value]).call.to_i }
        end
        
        def play_children
          
          status_name = @tree[:status_name].to_s
          resilience  = (@resilience || create_resilience).call
          history[:children] = { :just_after => just_after(:resilience, resilience) }
          
          # 回復力決定前
          play_(:before, :before, :Resilience)
          play_(:before, :before, :"#{status_name.underscore.camelize}Resilience")
          
          resilience = next_change!(:resilience, resilience)
          
          before_change = 対象.send(status_name).val
          対象.send(status_name).change_value(resilience)
          after_change  = 対象.send(status_name).val
          
          history[:children] = { :status_name => status_name, :resilience => resilience, :before_change => before_change, :after_change => after_change }
          
          # 回復力決定後
          play_(:after, :after, :"#{status_name.underscore.camelize}Resilience")
          play_(:after, :after, :Resilience)
          
        end
        
      end
    end
  end
end
