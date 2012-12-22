module DNU
  module Fight
    module Scene
      class After < BaseScene
        
        def before_each_scene
          @label = nil
          @active = @tree[:active]
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def before
        end
        
        def after
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:after] ||= []
          @history << { scene_name => { :children => [] } }
          history[:active]  = @active.try(:name)
          history[:passive] = @passive.try(:name)
          history[:parent] = "#{@tree[:parent]}(#{@tree[:object_id]})"
        end
        
      end
    end
  end
end
