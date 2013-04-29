class Result::Shout < ActiveRecord::Base
  belongs_to :day
  belongs_to :map_tip, :class_name => "GameData::MapTip"
  belongs_to :shout,   :class_name => "Register::Shout"
  
  has_one :user, :through => :shout
  
  validates :day,     :presence => true
  validates :map_tip, :presence => true
  validates :shout,   :presence => true
end
