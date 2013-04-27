class Result::Dispose < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :dispose, :class_name => "Register::Dispose"
  belongs_to :item
  attr_accessible :success
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day, :presence => true
  validates :dispose,    :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end
