module DNU
  module Process
    module Update
      extend Before
      extend Learning
      extend After
      
      def self.start(new_day = nil)
        @new_day = new_day
        
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
