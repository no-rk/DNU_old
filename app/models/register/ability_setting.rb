class Register::AbilitySetting < ActiveRecord::Base
  belongs_to :ability_conf
  belongs_to :ability_definition, :class_name => "GameData::AbilityDefinition"
  attr_accessible :setting, :ability_definition_id
  
  has_one :game_data_ability, :through => :ability_conf, :class_name => "GameData::Ability"
  
  validates :ability_definition, :presence => true
  validates :setting,            :allow_nil => true, :inclusion => { :in => [true, false] }
end
