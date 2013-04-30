module DNU
  module Process
    module Purchase
      
      def purchase
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:event).exists?
            user.register(:event).each do |event|
              event.purchases.each do |purchase|
                user.create_result!(:purchase, {
                  :purchase => purchase,
                  :success  => purchase.purchase!
                })
              end
            end
          end
        end
      end
      
    end
  end
end
