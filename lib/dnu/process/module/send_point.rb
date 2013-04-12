module DNU
  module Process
    module SendPoint
      
      def send_point
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:trade).present?
            user.register(:trade).send_points.includes(:point).each do |send_point|
              result_point = user.result(:point).where(:point_id => send_point.point_id).first
              
              user.create_result!(:send_point, {
                :send_point => send_point,
                :success    => result_point.send_to_user!(send_point.user, send_point.value)
              })
            end
          end
        end
      end
      
    end
  end
end
