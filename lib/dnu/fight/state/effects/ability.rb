module DNU
  module Fight
    module State
      class Ability < BaseEffects
        
        def when_initialize(tree)
          # �A�r���e�B��LV�͐퓬���ɕω����Ȃ�
          @LV = tree[:lv]
          # �A�r���e�BLV�ɉ�����LV���ʂ�ǉ�
          tree[:definitions].each do |effects|
            tree[:effects] += effects[:effects] if @LV>=effects[:lv]
          end
        end
        
      end
    end
  end
end
