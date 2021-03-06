module DNU
  module Process
    module Before
      
      def before
        now_day = Day.maximum(:day).to_i
        # 新更新の場合は日付進める
        now_day += 1 if @new_day
        
        now_day = Day.where(:day => now_day).first_or_create!
        
        # 再更新の場合は叫び, PT結果, マップクリア
        unless @new_day
          day_arel = Day.arel_table
          Result::Shout.where(day_arel[:day].eq(now_day.day)).includes(:day).destroy_all
          Result::Party.where(day_arel[:day].eq(now_day.day)).includes(:day).destroy_all
          Result::Map.where(day_arel[:day].eq(now_day.day)).includes(:day).destroy_all
        end
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          # 最新宣言に日数の情報を付与する
          [:main, :trade, :product, :event, :battle, :pet, :skill, :art, :message, :character].each do |form_name|
            user_forms = user.next_forms(form_name)
            if user_forms.present? and @new_day
              user_forms.each do |user_form|
                # 新登録があるならそれを採用
                if user_form.day.nil?
                  user_form.day = now_day
                  user_form.save!
                # 新登録がなくても一部フォームは古登録を採用
                elsif [:main, :battle, :pet, :skill, :art, :character].any?{ |f| f==form_name }
                  case form_name
                  when  :main
                    # 合言葉だけ引き継ぐ
                    if user_form.party_slogan.present?
                      new_form = Register::Main.new
                      new_form.user = user
                      new_form.day  = now_day
                      new_form.build_party_slogan
                      new_form.party_slogan.slogan = user_form.party_slogan.slogan
                      new_form.save!
                    end
                  else
                    new_form = DNU::DeepClone.register(user_form)
                    new_form.day  = now_day
                    new_form.save!
                  end
                end
              end
              # この時点で日数の情報が付いていない登録は削除
              user.send("register_#{form_name.to_s.pluralize}").where(:day_id => nil).destroy_all
            end
          end
          
          # 再更新の場合は結果クリア
          unless @new_day
            user.result(:passed_day, now_day.day).destroy_all
          end
          user.create_result!(:passed_day, { :day => now_day, :passed_day => (now_day.day.to_i - user.creation_day.to_i) })
          # 前日の結果を初期値としてコピー
          [:art, :inventory, :place, :point, :skill, :status, :event, :pet_inventory].each do |result_name|
            user.result(result_name, now_day.before_i).each do |result|
              result_c = DNU::DeepClone.register(result)
              result_c.passed_day = user.result(:passed_day, now_day.day).last
              result_c.save!
            end
          end
          
          # 設定を結果に反映
          [:skill, :art].each do |setting_name|
            if user.register(setting_name).exists?
              user.register(setting_name).each do |conf|
                result = user.result(setting_name).where("#{setting_name}_id" => conf.send("#{setting_name}_id")).first
                if result.present?
                  result.send("#{setting_name}_conf=", conf)
                  result.save!
                else
                  conf.destroy
                end
              end
            end
          end
        end
      end
      
    end
  end
end
