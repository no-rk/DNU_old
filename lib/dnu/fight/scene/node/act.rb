module DNU
  module Fight
    module Scene
      class Act < BaseScene
        
        def before_each_scene
          @active.call.行動数.change_value(1)
        end
        
        def play_children
          if @active.call.next_act?
            create_from_hash(@active.call.next_act!).play
          else
            super
          end
        end
        
      end
    end
  end
end
