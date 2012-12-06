module DNU
  module Fight
    module Scene
      class Turn < Base
        
        # 最初に行動を生成
        def initial_children
          [Act.new(@character,{:parent => self, :active => @active})]
        end
        
        # 状況に応じて追加行動を生成
        def create_child
          child = AddAct.new(@character,{:parent => self, :active => @active})
          child if rand(100) < 50
        end
        
      end
    end
  end
end
