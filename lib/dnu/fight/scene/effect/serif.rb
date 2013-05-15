module DNU
  module Fight
    module Scene
      class Serif < BaseEffect
        def play_children
          history[:children] = DNU::Text.new(自分.object, 対象.object).message(@tree.to_s)
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
