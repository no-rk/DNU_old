module DNU
  module Fight
    module State
      class Ability < BaseEffects
        
        def when_initialize(tree)
          # アビリティのLVは戦闘中に変化しない
          @LV = tree[:lv]
          # 選択されたプルダウン
          @pull_down = tree[:pull_down]
          # アビリティLVに応じてLV効果を追加
          tree[:definitions].each do |effects|
            if effects[:pull_down].present?
              tree[:effects] += effects[:effects] if @LV.to_i>=effects[:lv].to_i and @pull_down.to_s==effects[:pull_down].to_s
            else
              tree[:effects] += effects[:effects] if @LV.to_i>=effects[:lv].to_i
            end
          end
        end
        
      end
    end
  end
end
