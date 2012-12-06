module DNU
  module Fight
    module Scene
      class BaseFight < Base
        
        # 最初に非接触フェイズを生成
        def initial_children
          [PrePhase.new(@character,{:parent => self, :active => @character.live})]
        end
        
        # 2チーム以上が残っていたら次の通常フェイズを生成
        def create_child
          Phase.new(@character,{:parent => self, :active => @character.live}) if @character.live.team.count >= 2
        end
        
      end
    end
  end
end
