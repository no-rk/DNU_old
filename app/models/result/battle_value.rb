class Result::BattleValue < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :battle_value, :class_name => "GameData::BattleValue"
  attr_accessible :value
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day,   :presence => true
  validates :battle_value, :presence => true
end
