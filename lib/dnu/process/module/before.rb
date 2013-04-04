module DNU
  module Process
    module Before
      
      def before
        now_day = Day.maximum(:day).to_i
        # 新更新の場合は日付進める
        now_day += 1 if @new_day
        
        now_day = Day.where(:day => now_day).first_or_create!
        
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          # 最新宣言に日数の情報を付与する
          [:main, :trade, :product, :battle, :duel, :competition, :character].each do |form_name|
            user_form = user.send(form_name)
            if user_form and @new_day
              # 新登録があるならそれを採用
              if user_form.day.nil?
                user_form.day = now_day
                user_form.save!
              # 新登録がなくても一部フォームは古登録を採用
              elsif [:battle, :duel, :competition, :character].any?{ |f| f==form_name }
                user_form = DNU::DeepClone.register(user_form)
                user_form.day  = now_day
                user_form.save!
              end
              # この時点で日数の情報が付いていない登録は削除
              user.send(form_name.to_s.pluralize).where(:day_id => nil).destroy_all
            end
          end
          
          # 前日の結果を初期値としてコピー
          [:place, :inventory, :point, :status, :job, :art, :product, :ability, :skill].each do |result_name|
            # 再更新の場合は結果クリア
            unless @new_day
              case result_name
              when :place
                user.result(:places, now_day.day).destroy_all
              else
                user.result(result_name, now_day.day).destroy_all
              end
            end
            user.result(result_name, now_day.before_i).each do |result|
              result_c = DNU::DeepClone.result(result)
              result_c.day = now_day
              result_c.save!
            end
          end
        end
      end
      
    end
  end
end
