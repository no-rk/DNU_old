module DNU
  module Process
    module Forge
      
      def forge
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:product).present?
            user.register(:product).forges.each do |forge|
              from_item = forge.user.result(:inventory).where(:number => forge.number).first.try(:item) if forge.user.present?
              to_item   = forge.forge!
              
              user.create_result!(:forge, {
                :forge   => forge,
                :from    => from_item,
                :to      => to_item,
                :success => to_item.present?
              })
            end
          end
        end
      end
      
    end
  end
end
