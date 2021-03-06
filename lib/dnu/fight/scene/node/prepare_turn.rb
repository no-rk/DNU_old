# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class PrepareTurn < BaseScene
        
        # 生存していてターンエンドしてないキャラクターが居たら次ターンがある
        def has_next_scene?
          @character.live.turn_end_not.count > 0
        end
        
        # SPDなどに応じて順番に俺のターン
        def before_each_scene
          active_now = @character.live.turn_end_not.max{ |a,b| a.SPD <=> b.SPD }
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
        
        def play_children
          if @active.call.next_turn?
            create_from_hash(@active.call.next_turn!).play
          else
            super
          end
        end
        
        def log_before_each_scene
          super
          history[:HP]  = @active.call.HP.to_i
          history[:MHP] = @active.call.最大HP.to_i
          history[:MP]  = @active.call.MP.to_i
          history[:MMP] = @active.call.最大MP.to_i
        end
        
      end
    end
  end
end
