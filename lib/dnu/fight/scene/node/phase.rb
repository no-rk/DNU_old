module DNU
  module Fight
    module Scene
      class Phase < BaseScene
        
        # 残りチーム数が1になるか最大フェイズに達するまで次フェイズがある
        def has_next_scene?
          @character.live.team.count > 1 and @index < 10
        end
        
      end
    end
  end
end
