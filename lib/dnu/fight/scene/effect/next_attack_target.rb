# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextAttackTarget < BaseEffect
        include Calculate
        include FindTarget
        
        def play_children
          target = @tree.to_hash
          
          target = send(target.keys.first, target.values.first).sample
          対象.next_attack_target = target.respond_to?(:call) ? target.call : target
          
          history[:children] = { :target => target.name }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
