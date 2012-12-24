module DNU
  module Fight
    module Scene
      class Serif < BaseScene
        
        def play_children
          history[:children] = @tree
        end
        
      end
    end
  end
end
