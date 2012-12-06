module DNU
  module Fight
    module Scene
      class Cemetery < Base
        
        # HPが0以下のキャラクターにフラグつける
        def play_children
          @character.each do |chara|
            chara.dead = true if chara.HP.value <= 0
          end
        end
        
      end
    end
  end
end
