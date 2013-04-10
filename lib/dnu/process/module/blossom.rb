module DNU
  module Process
    module Blossom
      
      def blossom
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).blossoms.includes(:train).each do |blossom|
              user.blossom(blossom.train.trainable)
            end
          end
        end
      end
      
    end
  end
end