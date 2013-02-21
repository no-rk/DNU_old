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
          if user.make
            [:main, :trade, :product, :battle, :duel, :competition].each do |form_name|
              user_form = user.send(form_name)
              if user_form
                if user_form.day.nil?
                  user_form.day = now_day
                  user_form.save!
                elsif [:battle, :duel, :competition].any?{ |f| f==form_name }
                  # 日数が付与されてたらクローンする
                  user_form = DNU::DeepClone.register(user_form)
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
