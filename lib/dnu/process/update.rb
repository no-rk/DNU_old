module DNU
  module Process
    module Update
      extend Before
      extend Dispose
      extend SendPoint
      extend SendItem
      extend Purchase
      extend CatchPet
      extend ItemUse
      extend Forge
      extend Supplement
      extend Equip
      extend Battle
      extend Train
      extend Learn
      extend Forget
      extend Blossom
      extend Grow
      extend Move
      extend Party
      extend AfterMove
      extend Notice
      extend Shout
      extend Map
      extend After
      
      def self.start(new_day = nil)
        @new_day = new_day
        
        # (最新結果が確定済かつ新更新)または(最新結果が未確定かつ再更新)のときだけ更新処理する
        if (Day.settled? and @new_day) or ((Day.pending? or Day.updating?) and @new_day.nil?)
          # 更新前処理
          before
          
          # アイテム破棄
          dispose
          
          # ポイント送付
          send_point
          
          # アイテム送付
          send_item
          
          # アイテム購入
          purchase
          
          # ペット捕獲
          catch_pet
          
          # アイテム使用
          item_use
          
          # 鍛治
          forge
          
          # 付加
          supplement
          
          # 装備
          equip
          
          # 戦闘
          battle
          
          # 能力や技能や生産やアビリティの訓練
          train
          
          # 技やアビリティの習得
          learn
          
          # 技能の忘却
          forget
          
          # 技能の開花
          blossom
          
          # 成長
          grow
          
          # 移動
          move
          
          # PT結成
          party
          
          # 移動後
          after_move
          
          # 戦闘予告
          notice
          
          # 叫び
          shout
          
          # マップ生成
          map
          
          # 更新後処理
          after
        end
      end
      
    end
  end
end
