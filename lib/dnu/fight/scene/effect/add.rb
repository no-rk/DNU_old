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
          la = lambda do
            r = depth
            r = 自分.next_depth.call(r)     if 自分.next_depth?
            r = 対象.next_depth_ant.call(r) if 対象.next_depth_ant?
            r
          end
          history[:children] = { :just_after => la }
          
          # 追加量決定前
          play_(:before, :before, :Depth)
          play_(:before, :before, :"#{disease_name}Depth")
          
          depth = 自分.next_depth!.call(depth)     if 自分.next_depth?
          depth = 対象.next_depth_ant!.call(depth) if 対象.next_depth_ant?
          
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
