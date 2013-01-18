# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextAct < BaseEffect
        
        def play_children
          # 構文木もたせる
          対象.next_act = @tree
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
