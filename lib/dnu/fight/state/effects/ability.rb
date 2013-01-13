module DNU
  module Fight
    module State
      class Ability < BaseEffects
        
        def when_initialize(tree)
          # アビリティのLVは戦闘中に変化しない
          @LV = tree[:lv]
          # アビリティLVに応じてLV効果を追加
          tree[:definitions].each do |effects|
            tree[:effects] += effects[:effects] if @LV>=effects[:lv]
          end
        end
        
      end
    end
  end
end
