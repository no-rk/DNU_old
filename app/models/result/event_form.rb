class Result::EventForm < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :event_content, :class_name => "GameData::EventContent"
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day,    :presence => true
  validates :event_content, :presence => true
end
