module DNU
  module Fight
    module Scene
      class BaseFight < Base
        def initial_children
          [PrePhase.new(self.character)]
        end
        
        # 2�`�[���ȏオ�c���Ă����玟�̃t�F�C�Y�𐶐�
        def create_child
          Phase.new(self.character) if character.team_count >= 2
        end
      end
    end
  end
end
