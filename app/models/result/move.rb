class Result::Move < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :from, :class_name => "GameData::MapTip"
  belongs_to :to,   :class_name => "GameData::MapTip"
  attr_accessible :direction, :success
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day, :presence => true
  validates :direction,  :presence => true
  validates :from,       :presence => true
  validates :to,         :presence => true
end
