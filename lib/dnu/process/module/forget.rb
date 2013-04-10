module DNU
  module Process
    module Forget
      
      def forget
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).forgets.includes(:train).each do |forget|
              result_forget = Result::Forget.new
              result_forget.user = user
              result_forget.day = Day.last
              result_forget.forgettable = forget.train.trainable
              result_forget.success = user.forget!(forget.train.trainable)
              result_forget.save!
            end
          end
        end
      end
      
    end
  end
end
