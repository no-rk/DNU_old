# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextAttackTarget < BaseEffect
        include Calculate
        
        def play_children
          target = send(@tree[:target].to_s)
          
          対象.next_attack_target = target
          
          history[:children] = { :target => target.name }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end