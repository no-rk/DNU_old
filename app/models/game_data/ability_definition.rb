class GameData::AbilityDefinition < ActiveRecord::Base
  belongs_to :ability
  attr_accessible :caption, :lv, :kind
  
  has_many :ability_settings, :dependent => :destroy, :class_name => "Register::AbilitySetting"
  
  validates :kind, :inclusion => { :in => [:lv, :pull_down] }
  validates :lv,   :numericality => { :only_integer => true, :greater_than => 0 }
end
