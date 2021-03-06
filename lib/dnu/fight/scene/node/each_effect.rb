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
        
        def after_each_scene
          @label[:each_effect].try(:pop)
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play_children
          catch @each_effect.keys.first do
            super
          end
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
