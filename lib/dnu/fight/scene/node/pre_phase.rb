module DNU
  module Fight
    module Scene
      class PrePhase < BaseScene
        
        def log_before_each_scene
          super
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
