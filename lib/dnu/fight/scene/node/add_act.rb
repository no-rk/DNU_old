module DNU
  module Fight
    module Scene
      class AddAct < BaseScene
        
        # SPD�Ȃǂɉ����Ēǉ��s�������邩������Ȃ�
        def has_next_scene?
          rand(100) < 50
        end
        
      end
    end
  end
end
