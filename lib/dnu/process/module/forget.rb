module DNU
  module Process
    module Forget
      
      def forget
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).forgets.includes(:train).each do |forget|
              result_art = user.forget!(forget.train.trainable)
              user.create_result!(:forget, {
                :forgettable => forget.train.trainable,
                :lv          => result_art.try(:lv),
                :success     => result_art.present?
              })
            end
          end
        end
      end
      
    end
  end
end
