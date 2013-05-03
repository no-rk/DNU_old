module DNU
  module Fight
    module State
      class Art < BaseEffects
        
        def when_initialize(tree)
          # 技能のLVは戦闘中に変化しない
          @LV = tree[:lv]
          # 無効にされたLV効果
          @lv_effects = tree[:lv_effects] || []
          # 選択されたプルダウン
          @pull_down = tree[:pull_down]
          # 技能LVに応じてLV効果を追加
          tree[:definitions].each do |effects|
            if effects[:pull_down].present?
              tree[:effects] += effects[:effects] if @LV.to_i>=effects[:lv].to_i and @pull_down.to_s==effects[:pull_down].to_s
            else
              tree[:effects] += effects[:effects] if @LV.to_i>=effects[:lv].to_i and not @lv_effects.include?(effects[:lv].to_i)
            end
          end
        end
        
      end
    end
  end
end
