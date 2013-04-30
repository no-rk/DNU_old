class Result::Purchase < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :purchase, :class_name => "Register::Purchase"
  belongs_to :item,     :class_name => "Result::Item"
  attr_accessible :success, :number
  
  has_one :user,          :through => :passed_day
  has_one :day,           :through => :passed_day
  
  has_one :game_data_item, :through => :purchase, :source => :item
  has_one :event_content,  :through => :purchase
  
  validates :passed_day, :presence => true
  validates :purchase,   :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end
