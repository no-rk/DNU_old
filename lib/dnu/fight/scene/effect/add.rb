# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Add < BaseEffect
        include Calculate
        
        def when_initialize
          @depth = nil
        end
        
        def create_depth
          @depth ||= lambda{ calcu_value(@tree[:change_value]).call.to_i }
        end
        
        def play_children
          
          disease_name = child_name(@tree[:disease_name])
          depth        = (@depth || create_depth).call
          history[:children] = { :just_after => just_after(:depth, depth) }
          
          # 追加量決定前
          play_(:before, :before, :Depth)
          play_(:before, :before, :"#{disease_name}Depth")
          
          depth = next_change!(:depth, depth)
          
          before_change = 対象.send(disease_name).val
          対象.send(disease_name).change_value(depth)
          after_change  = 対象.send(disease_name).val
          
          history[:children] = { :disease_name => disease_name, :before_change => before_change, :after_change => after_change }
          
          # 追加量決定後
          play_(:after, :after, :"#{disease_name}Depth")
          play_(:after, :after, :Depth)
          
        end
        
      end
    end
  end
end
