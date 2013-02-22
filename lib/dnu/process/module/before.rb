module DNU
  module Process
    module Before
      
      def before
        now_day = Day.maximum(:day) || 0
        # 新更新の場合は日付進める
        now_day += 1 if @new_day
        
        now_day = Day.create!(:day => now_day)
        
        # キャラ作成済みの各ユーザーの最新宣言に日数の情報を付与する
        User.find_each do |user|
          if user.make.present?
            [:main, :trade, :product, :battle, :duel, :competition].each do |form_name|
              user_form = user.send(form_name)
              if user_form
                # 新更新の場合
                if @new_day
                  # 新登録があるならそれを採用
                  if user_form.day.nil?
                    user_form.day = now_day
                    user_form.save!
                  # 新登録がなくても一部フォームは古登録を採用
                  elsif [:battle, :duel, :competition].any?{ |f| f==form_name }
                    user_form = DNU::DeepClone.register(user_form)
                    user_form.day  = now_day
                    user_form.save!
                  end
                  # この時点で日数の情報が付いていない登録は削除
                  user.send(form_name.to_s.pluralize).where(:day_id => nil).destroy_all
                # 再更新の場合は新更新で採用した登録を使いまわす
                elsif user_form.day.day == now_day.day
                  user_form.day  = now_day
                  user_form.save!
                end
              end
            end
          end
        end
      end
      
    end
  end
end
