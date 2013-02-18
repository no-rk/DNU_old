module DNU
  module Fight
    module Scene
      class Phase < BaseScene
        
        # 残りチーム数が1になるか最大フェイズに達するまで次フェイズがある
        def has_next_scene?
          @character.live.team.count > 1 and @index < 10
        end
        
        def create_after_each
          @after_each ||= create_from_hash({ :append => @tree[:after_each]})
        end
        
        def after_each_scene
          @after_each.try(:play) || create_after_each.play
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def log_before_each_scene
          super
          history[:index] = @index + 1
          history[:active] = []
          @active.call.team.each do |team|
            child = { team.name.to_sym => [] }
            @active.call.find_by_team(team).each do |char|
               child.values.first << {
                :active => char.name,
                :HP  => char.HP.val,
                :MHP => char.MHP.val,
                :MP  => char.MP.val,
                :MMP => char.MMP.val,
                :Position => char.Position.val,
                :Range => char.Range.val
              }
            end
            history[:active] << child
          end
        end
        
      end
    end
  end
end
