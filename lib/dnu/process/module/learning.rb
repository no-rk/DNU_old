module DNU
  module Process
    module Learning
      
      def learning
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          # 技習得
          GameData::LearningCondition.find_learnable(user.result_state, :skill).each do |skill|
            # いままで未修得だったら習得
            if user.result_skills.where(:skill_id => skill.id).count == 0
              result_skill = Result::Skill.new
              result_skill.character = user
              result_skill.day = Day.last
              result_skill.skill = skill
              result_skill.exp = 0
              result_skill.forget = false
              result_skill.save!
            end
          end
        end
      end
      
    end
  end
end
