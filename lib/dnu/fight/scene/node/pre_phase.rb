module DNU
  module Fight
    module Scene
      class PrePhase < Base
        
        # 生存しているキャラクターのターンを生成
        def initial_children
          children = []
          @character.live.each do |chara|
            children << Turn.new(@character, {:parent => self, :active => chara})
          end
          children
        end
        
        # 行動順を決定
        def sort
        end
        
        # 全員のターンが終わった後に一度だけ墓地埋葬処理を追加
        def create_child
          unless @once
            @once = true
            Cemetery.new(@character, {:parent => self})
          end
        end
        
      end
    end
  end
end
