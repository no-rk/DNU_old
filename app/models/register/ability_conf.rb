class Register::AbilityConf < ActiveRecord::Base
  belongs_to :ability
  belongs_to :game_data_ability, :class_name => "GameData::Ability"
  attr_accessible :kind, :game_data_ability_id
  
  has_one  :ability_name, :dependent => :destroy
  has_many :ability_settings, :order => "ability_definition_id ASC", :dependent => :destroy
  
  accepts_nested_attributes_for :ability_name
  accepts_nested_attributes_for :ability_settings
  
  attr_accessible :ability_name_attributes, :ability_settings_attributes
  
  validates :game_data_ability, :presence => true
  validates :kind,              :inclusion => { :in => ["battle"] }
end
