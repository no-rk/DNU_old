module DNU
  module Fight
    module Scene
      class Phase < BaseScene
        
        # �c��`�[������1�ɂȂ邩�ő�t�F�C�Y�ɒB����܂Ŏ��t�F�C�Y������
        def has_next_scene?
          @character.live.team.count > 1 and @index < 3
        end
        
      end
    end
  end
end
