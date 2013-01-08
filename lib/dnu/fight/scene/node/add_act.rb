module DNU
  module Fight
    module Scene
      class AddAct < BaseScene
        
        # SPDなどに応じて追加行動があるかもしれない
        def has_next_scene?
          @active.call.SPD > 1000*(@index+1)
        end
        
        def play_children
          history[:index] = @index + 1
          super
        end
        
      end
    end
  end
end
