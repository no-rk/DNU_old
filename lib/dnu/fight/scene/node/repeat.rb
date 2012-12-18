module DNU
  module Fight
    module Scene
      class Repeat < BaseScene
        
        def has_next_scene?
          @index < @tree[:times].to_i
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def before
        end
        
        def after
        end
        
        def history
          @parent.history
        end
        
        def log_before_each_scene
          @history = (@parent.try(:history) || { :children => [] })[:children]
        end
        
      end
    end
  end
end
