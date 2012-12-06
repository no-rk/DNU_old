module DNU
  module Fight
    module Scene
      class Act < Base
        
        # 行動可能であれば効果を生成
        def initial_children
          [Effect.new(@character,{:parent => self, :active => @active})]
        end
        
      end
    end
  end
end
