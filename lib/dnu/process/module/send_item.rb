module DNU
  module Process
    module SendItem
      
      def send_item
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:trade).present?
            user.register(:trade).send_items.each do |send_item|
              result_inventory = user.result(:inventory).where(:number => send_item.number).first
              
              user.create_result!(:send_item, {
                :send_item  => send_item,
                :number     => send_item.user.try(:blank_item_number),
                :item       => result_inventory.try(:item),
                :success    => result_inventory.nil? ? false : result_inventory.send_to_user!(send_item.user)
              })
            end
          end
        end
      end
      
    end
  end
end
