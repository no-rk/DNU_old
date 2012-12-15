module DNU
  module Fight
    module Scene
      class EachEffect < BaseScene
        
        def when_initialize
          @each_effect = { ("each_effect" + self.object_id.to_s).to_sym => @tree[:while] }
        end
        
        def before_each_scene
          @label[:each_effect].try(:push, @each_effect) || @label[:each_effect] = [ @each_effect ]
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play_children
          catch @each_effect.keys.first do
            super
          end
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
