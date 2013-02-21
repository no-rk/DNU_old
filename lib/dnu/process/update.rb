module DNU
  module Process
    module Update
      extend Before
      extend Learning
      extend After
      
      def self.start(new_day = nil)
        @new_day = new_day
        
        # (最新結果が確定済かつ新更新)または(最新結果が未確定かつ再更新)のときだけ更新処理する
        if (Day.settled? and @new_day) or (Day.pending? and @new_day.nil?)
          # 更新前処理
          before
          
          # 技やアビリティの習得
          learning
          
          # 更新後処理
          after
        end
      end
      
    end
  end
end
