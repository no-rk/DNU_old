module DNU
  module Fight
    module Scene
      class Effect < BaseScene
        include Condition
        
        def after_each_scene
          @label[:each_effect].try(:each) do |h|
            unless (h.values.first.respond_to?(:call) ? h.values.first : (h[h.keys.first] = condition(h.values.first))).call
              throw h.keys.first
            end
          end
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
