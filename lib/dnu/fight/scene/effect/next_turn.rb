# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextTurn < BaseEffect
        
        def play_children
          # 構文木もたせる
          対象.next_turn = @tree
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
