module DNU
  module Fight
    module Scene
      class Competition < BaseScene
        
        def before_each_scene
          @active = lambda{ @character.live }
        end
        
      end
    end
  end
end
