module DNU
  module Fight
    module Scene
      class Cemetery < BaseScene
        
        def play_children
          @character.live.each do |char|
            if char.HP <= 0
              char.dead = true
              history[:children] << char.name
            end
          end
        end
        
      end
    end
  end
end
