module DNU
  module Fight
    module Scene
      class AddAct < BaseScene
        
        # SPDなどに応じて追加行動があるかもしれない
        def has_next_scene?
          rand(100) < 50
        end
        
        def play_children
          history[:index] = @index + 1
          super
        end
        
      end
    end
  end
end
