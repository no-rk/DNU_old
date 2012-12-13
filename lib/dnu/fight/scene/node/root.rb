module DNU
  module Fight
    module Scene
      class Root < BaseScene
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
