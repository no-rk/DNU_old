module DNU
  module Fight
    module Scene
      class Sequence < BaseScene
        
        def when_initialize
          @sequence = []
        end
        
        def has_next_scene?
          @index < @tree.size
        end
        
        def before_each_scene
          @children = @sequence[@index]
        end
        
        def create_children
          @sequence[@index] = ( @children ||= create_from_hash(@tree[@index]) )
        end
        
        def play_(b_or_a)
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
