module DNU
  module Process
    module After
      
      def after
        now_day = Day.last
        
        # 日数ステータスを未確定にする。
        now_day.state = 1
        # 動作が安定したら即確定にする。
        # now_day.state = 2
        now_day.save!
      end
      
    end
  end
end
