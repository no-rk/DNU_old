module DNU
  module Fight
    module Scene
      class Random < BaseScene
        
        def when_initialize
          @random = []
          @random_index = 0
        end
        
        def before_each_scene
          @random_index = rand(@tree.length)
          @children = @random[@random_index]
        end
        
        def create_children
          @random[@random_index] = ( @children ||= create_from_hash(@tree[@random_index]) )
        end
        
        def play_before
        end
        
        def play_after
        end
        
        def history
          @parent.history
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:children] ||= []
        end
        
      end
    end
  end
end
