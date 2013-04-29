module DNU
  module Process
    module Train
      
      def train
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            user.register(:main).trains.includes(:train).each do |train|
              result_train = user.new_result(:train)
              case train.train.trainable_type.underscore.split("/").last.to_sym
              when :status
                result_status = user.result(:status).where(:status_id => train.train.trainable_id).first
                result_train.trainable = result_status
                result_train.from      = result_status.count
                result_train.success   = result_status.grow_using_point_name!
                result_train.to        = result_status.count
              when :art
                result_art = user.result(:art).where(:art_id => train.train.trainable_id).first
                result_train.trainable = result_art
                result_train.from      = result_art.lv
                result_train.success   = result_art.grow_using_point_name!
                result_train.to        = result_art.lv
              when :product
                result_product = user.result(:product).where(:product_id => train.train.trainable_id).first
                result_train.trainable = result_product
                result_train.from      = result_product.lv
                result_train.success   = result_product.grow_using_point_name!
                result_train.to        = result_product.lv
              when :ability
                result_ability = user.result(:ability).where(:ability_id => train.train.trainable_id).first
                result_train.trainable = result_ability
                result_train.from      = result_ability.lv
                result_train.success   = result_ability.grow_using_point_name!
                result_train.to        = result_ability.lv
              end
              result_train.save!
            end
          end
        end
      end
      
    end
  end
end
