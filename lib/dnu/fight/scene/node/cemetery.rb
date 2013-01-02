module DNU
  module Fight
    module Scene
      class Cemetery < BaseScene
        
        def play_children
          @character.live.find_all{ |c| c.HP <= 0 }.each do |char|
            char.dead = true
            history[:children] << char.name
          end
        end
        
      end
    end
  end
end
