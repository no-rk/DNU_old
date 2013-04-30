module DNU
  module Process
    module Purchase
      
      def purchase
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:event).exists?
            user.register(:event).each do |event|
              event.purchases.each do |purchase|
                result_inventory = purchase.purchase!
                
                user.create_result!(:purchase, {
                  :purchase => purchase,
                  :number   => result_inventory.number,
                  :item     => result_inventory.item,
                  :success  => result_inventory.present?
                })
              end
            end
          end
        end
      end
      
    end
  end
end
