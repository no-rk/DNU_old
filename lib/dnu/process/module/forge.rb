module DNU
  module Process
    module Forge
      
      def forge
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:product).present?
            user.register(:product).forges.each do |forge|
              inventory   = forge.user.result(:inventory).where(:number => forge.number).first if forge.user.present?
              result_item = forge.forge!
              
              user.create_result!(:forge, {
                :forge   => forge,
                :from    => inventory.try(:item),
                :to      => result_item,
                :success => result_item.present?
              })
            end
          end
        end
      end
      
    end
  end
end
