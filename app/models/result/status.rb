class Result::Status < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :status, :class_name => "GameData::Status"
  attr_accessible :count
end