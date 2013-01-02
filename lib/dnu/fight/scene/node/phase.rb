module DNU
  module Fight
    module Scene
      class Phase < BaseScene
        
        # 残りチーム数が1になるか最大フェイズに達するまで次フェイズがある
        def has_next_scene?
          @character.live.team.count > 1 and @index < 10
        end
        
        def log_before_each_scene
          super
          history[:index] = @index + 1
          history[:active] = []
          @active.call.each do |char|
            history[:active] << {
              :active => char.name,
              :HP  => char.HP.val,
              :MHP => char.MHP.val,
              :MP  => char.MP.val,
              :MMP => char.MMP.val,
              :Position => char.Position.val,
              :Range => char.Range.val
            }
          end
        end
        
      end
    end
  end
end
