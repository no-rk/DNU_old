class Register::AbilitySetting < ActiveRecord::Base
  belongs_to :ability
  belongs_to :ability_definition, :class_name => "GameData::AbilityDefinition"
  has_one :game_data_ability, :through => :ability_definition, :class_name => "GameData::Ability", :source => :ability
  attr_accessible :kind, :setting, :ability_definition_id
end
