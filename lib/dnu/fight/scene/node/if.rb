module DNU
  module Fight
    module Scene
      class If < BaseScene
        
        def create_children
          @children ||= create_from_hash(@tree[:then])
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
