module DNU
  module Process
    module Learn
      
      def learn
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          result_state = user.result(:state)
          # 技習得
          GameData::LearningCondition.find_learnable(result_state, :skill).each do |skill|
            # いままで未修得だったら習得
            if user.result(:skill).where(:skill_id => skill.id).count == 0
              user.create_result!(:skill, {
                :skill  => skill,
                :exp    => 0,
                :forget => false
              })
              user.create_result!(:learn, {
                :learnable => skill,
                :first     => Result::Skill.first_learn?(skill.id)
              })
            end
          end
          # アビリティー習得
          GameData::LearningCondition.find_learnable(result_state, :ability).each do |ability|
            # いままで未修得だったら習得
            if user.result(:ability).where(:ability_id => ability.id).count == 0
              user.create_result!(:ability, {
                :ability => ability,
                :lv => 1,
                :lv_exp => 0,
                :forget => false
              })
              user.create_result!(:learn, {
                :learnable => ability,
                :first     => Result::Ability.first_learn?(ability.id)
              })
            end
          end
        end
      end
      
    end
  end
end
