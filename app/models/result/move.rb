class Result::Move < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :from, :class_name => "GameData::MapTip"
  belongs_to :to, :class_name => "GameData::MapTip"
  attr_accessible :direction, :success
end
