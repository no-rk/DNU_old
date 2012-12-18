module DNU
  module Fight
    module Scene
      class Cemetery < BaseScene
        
        def play_children
          history[:children] = human_name
        end
        
      end
    end
  end
end
