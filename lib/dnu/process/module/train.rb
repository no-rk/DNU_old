module DNU
  module Process
    module Train
      
      def train
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).trains.includes(:train).each do |train|
              case train.train.trainable_type.underscore.split("/").last.to_sym
              when :status
                result_status = user.result(:status).where(:status_id => train.train.trainable_id).first
                result_status.grow_using_point_name!(:NP)
              when :art
                result_art = user.result(:art).where(:art_id => train.train.trainable_id).first
                result_art.grow_using_point_name!(:GP)
              when :product
                result_product = user.result(:product).where(:product_id => train.train.trainable_id).first
                result_product.grow_using_point_name!(:SP)
              when :ability
                result_ability = user.result(:ability).where(:ability_id => train.train.trainable_id).first
                result_ability.grow_using_point_name!(:AP)
              end
            end
          end
        end
      end
      
    end
  end
end
