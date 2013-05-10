module DNU
  module Fight
    module Scene
      class Serif < BaseEffect
        def play_children
          history[:children] = DNU::Text.message(@tree.to_s)
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
