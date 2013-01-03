module DNU
  module Fight
    module Scene
      class Repeat < BaseScene
        include Calculate
        
        def has_next_scene?
          next_scene
          @index < calcu_value(@tree[:times]).call
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
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
