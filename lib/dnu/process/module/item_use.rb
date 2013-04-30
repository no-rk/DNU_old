module DNU
  module Process
    module ItemUse
      
      def item_use
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).item_uses.each do |item_use|
              
            end
          end
        end
      end
      
    end
  end
end
