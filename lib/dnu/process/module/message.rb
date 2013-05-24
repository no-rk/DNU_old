module DNU
  module Process
    module Message
      
      def message
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:message).present?
            user.register(:message).message_users.each do |message_user|
              user.create_result!(:message_user, {
                :message_user => message_user,
                :html         => message_user.body_html
              })
            end
          end
        end
      end
      
    end
  end
end
