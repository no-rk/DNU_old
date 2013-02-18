module DNU
  module Fight
    module Scene
      class Append < BaseScene
        
        def history
          @parent.parent.history
        end
        
        def log_before_each_scene
          @history = @parent.parent.try(:history) || {}
          @history = @history[:children] ||= []
        end
        
      end
    end
  end
end
