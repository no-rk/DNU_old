module DNU
  module Process
    module Update
      extend Before
      extend SendPoint
      extend SendItem
      extend Forge
      extend Train
      extend Learn
      extend Forget
      extend Blossom
      extend Grow
      extend Move
      extend Party
      extend Map
      extend After
      
      def self.start(new_day = nil)
        @new_day = new_day
        
        # (最新結果が確定済かつ新更新)または(最新結果が未確定かつ再更新)のときだけ更新処理する
        if (Day.settled? and @new_day) or (Day.pending? and @new_day.nil?)
          # 更新前処理
          before
          
          # ポイント送付
          send_point
          
          # アイテム送付
          send_item
          
          # 鍛治
          forge
          
          # 能力や技能や生産やアビリティーの訓練
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
          
          # マップ生成
          map
          
          # 更新後処理
          after
        end
      end
      
    end
  end
end
