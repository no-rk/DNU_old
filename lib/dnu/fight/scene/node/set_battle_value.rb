module DNU
  module Fight
    module Scene
      class SetBattleValue < BaseScene
        
        def before_each_scene
          @active = lambda{ @character.live }
        end
        
        def play_children
          # 戦闘値決定時の特殊効果を発動する
          play_(:children, :children, :BattleVal)
        end
        
      end
    end
  end
end
