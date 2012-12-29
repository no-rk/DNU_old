module DNU
  module Fight
    module Scene
      class Effects < BaseScene
        
        def before_each_scene
          @label = nil
          @stack.push(@tree[:effects])
        end
        
        def after_each_scene
          @stack.pop
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:effects].do)
        end
        
        def play_children
          history[:id]      = @tree[:effects].object_id
          history[:type]    = @tree[:effects].type
          history[:name]    = @tree[:effects].name
          catch :"#{@tree[:effects].type}#{@tree[:effects].object_id}" do
            super
          end
        end
        
      end
    end
  end
end
