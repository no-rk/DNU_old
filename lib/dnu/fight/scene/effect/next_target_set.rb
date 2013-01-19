# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextTargetSet < BaseEffect
        include Calculate
        
        def play_children
          target_set = @tree.to_hash
          
          対象.next_target_set = target_set
          
          history[:children] = { :target_set => target_set }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
