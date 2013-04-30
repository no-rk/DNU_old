class Result::Purchase < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :purchase, :class_name => "Register::Purchase"
  attr_accessible :success
  
  has_one :user,          :through => :passed_day
  has_one :day,           :through => :passed_day
  
  has_one :item,          :through => :purchase
  has_one :event_content, :through => :purchase
  
  validates :passed_day, :presence => true
  validates :purchase,   :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end
