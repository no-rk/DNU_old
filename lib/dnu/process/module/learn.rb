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
          # 技能習得
          GameData::LearningCondition.find_learnable(result_state, :art).each do |art|
            # いままで未修得だったら習得
            if user.result(:art).where(:art_id => art.id).count == 0
              user.add_art!(art.type => art.name)
              user.create_result!(:learn, {
                :learnable => art,
                :first     => Result::Art.first_learn?(art.id)
              })
            end
          end
        end
      end
      
    end
  end
end
