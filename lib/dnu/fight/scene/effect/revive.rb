# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Revive < BaseScene
        include Calculate
        
        def when_initialize
          @change = nil
        end
        
        def create_change
          @change ||= lambda{ calcu_value(@tree[:change_to]).call.to_i }
        end
        
        def play_children
          if 対象.dead
            # 死亡フラグ外してターンエンドフラグ立てる
            対象.dead = nil
            対象.turn_end = true
            
            change = (@change || create_change).call
            
            before_change = 対象.HP.val
            対象.HP.change_to(change)
            after_change  = 対象.HP.val
            
            history[:children] = { :before_change => before_change, :after_change => after_change }
          else
            history[:children] = { :live => true }
          end
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
