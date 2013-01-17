module DNU
  module Fight
    module Scene
      class Nothing < BaseEffect
        
        def play_children
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
