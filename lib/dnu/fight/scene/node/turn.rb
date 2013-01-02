# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Turn < BaseScene
        
        # 生存していてターンエンドしてないキャラクターが居たら次ターンがある
        def has_next_scene?
          @character.live.turn_end_not.count > 0
        end
        
        # SPDなどに応じて順番に俺のターン
        def before_each_scene
          active_now = @character.live.turn_end_not.高(:status_name => :SPD).call
          @active = lambda{ active_now }
        end
        
        def after_each_scene
          @active.call.turn_end = true
        end
        
        def after_all_scene
          @character.each do |chara|
            chara.turn_end = nil
          end
        end
        
      end
    end
  end
end
