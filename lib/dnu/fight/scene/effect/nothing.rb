module DNU
  module Fight
    module Scene
      class Nothing < BaseScene
        
        def play_children
        end
        
        def before
        end
        
        def after
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
