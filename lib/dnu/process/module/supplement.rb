module DNU
  module Process
    module Supplement
      
      def supplement
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:product).present?
            user.register(:product).supplements.each do |supplement|
              from_item = supplement.user.result(:inventory).where(:number => supplement.material_number).first.try(:item) if supplement.user.present?
              to_item   = supplement.user.result(:inventory).where(:number => supplement.item_number).first.try(:item) if supplement.user.present?
              
              item_sup = supplement.supplement!
              user.create_result!(:supplement, {
                :supplement => supplement,
                :from       => from_item,
                :to         => to_item,
                :item_sup   => item_sup,
                :success    => item_sup.present?
              })
            end
          end
        end
      end
      
    end
  end
end
