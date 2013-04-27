module DNU
  module Process
    module Dispose
      
      def dispose
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).disposes.each do |dispose|
              result_item = user.dispose!(dispose.number)
              
              user.create_result!(:dispose, {
                :dispose  => dispose,
                :item     => result_item,
                :success  => result_item.try(:dispose_protect)==false
              })
            end
          end
        end
      end
      
    end
  end
end
