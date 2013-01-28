module DNU
  module Process
    class Update
      include Learning
      
      def start
        
        # 技やアビリティの習得
        learning
        
      end
      
    end
  end
end
