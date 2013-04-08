class Register::AbilitySetting < ActiveRecord::Base
  belongs_to :ability
  belongs_to :game_data_ability, :class_name => "GameData::Ability"
  attr_accessible :kind, :lv, :pull_down, :setting, :ability_id, :game_data_ability_id
end
