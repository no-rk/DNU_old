module DNU
  module Fight
    module Scene
      class Empty < BaseEffect
        
        def play_children
          history[:children] = @tree
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
