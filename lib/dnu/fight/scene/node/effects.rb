module DNU
  module Fight
    module Scene
      class Effects < BaseScene
        
        def when_initialize
          @effects = { ("effects" + self.object_id.to_s).to_sym => nil }
        end
        
        def before_each_scene
          @label[:effects].try(:push, @effects) || @label[:effects] = [ @effects ]
          @current = @tree[:current]
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play_children
          catch @effects.keys.first do
            super
          end
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:after] ||= []
          @history << { scene_name => { :children => [] } }
          history[:active]  = @active.try(:name)
          history[:passive] = @passive.try(:name)
          history[:id]      = @tree[:object_id]
          history[:type]    = @tree[:type]
          history[:name]    = @tree[:name]
        end
        
      end
    end
  end
end
