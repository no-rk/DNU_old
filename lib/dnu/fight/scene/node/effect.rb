module DNU
  module Fight
    module Scene
      class Effect < BaseScene
        
        def after_each_scene
          @label[:each_effect].try(:each) do |h|
            if rand(100)<50
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
          @history = (@parent.try(:history) || { :children => [] })[:children]
        end
        
      end
    end
  end
end
