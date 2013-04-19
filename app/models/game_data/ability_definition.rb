class GameData::AbilityDefinition < ActiveRecord::Base
  belongs_to :ability
  attr_accessible :caption, :lv, :kind
  
  has_many :ability_settings, :dependent => :destroy, :class_name => "Register::AbilitySetting"
end
