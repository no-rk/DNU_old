module DNU
  module Process
    module Blossom
      
      def blossom
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).blossoms.includes(:train).each do |blossom|
              result_blossom = Result::Blossom.new
              result_blossom.user = user
              result_blossom.day = Day.last
              result_blossom.blossomable = blossom.train.trainable
              result_blossom.success = user.blossom!(blossom.train.trainable)
              result_blossom.save!
            end
          end
        end
      end
      
    end
  end
end
