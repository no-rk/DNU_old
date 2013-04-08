module DNU
  module Process
    module Learning
      
      def learning
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          result_state = user.result(:state)
          # 技習得
          GameData::LearningCondition.find_learnable(result_state, :skill).each do |skill|
            # いままで未修得だったら習得
            if user.result(:skill).where(:skill_id => skill.id).count == 0
              result_skill = Result::Skill.new
              result_skill.character = user
              result_skill.day = Day.last
              result_skill.skill = skill
              result_skill.exp = 0
              result_skill.forget = false
              result_skill.save!
            end
          end
          # アビリティー習得
          GameData::LearningCondition.find_learnable(result_state, :ability).each do |ability|
            # いままで未修得だったら習得
            if user.result(:ability).where(:ability_id => ability.id).count == 0
              result_ability = Result::Ability.new
              result_ability.character = user
              result_ability.day = Day.last
              result_ability.ability = ability
              result_ability.lv = 1
              result_ability.lv_exp = 0
              result_ability.forget = false
              result_ability.save!
            end
          end
        end
      end
      
    end
  end
end
