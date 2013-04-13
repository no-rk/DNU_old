class Result::Forge < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :forge, :class_name => "Register::Forge"
  belongs_to :from,  :class_name => "Result::Item"
  belongs_to :to,    :class_name => "Result::Item"
  attr_accessible :success
  
  has_one :user,   :through => :passed_day
  has_one :day,    :through => :passed_day
  has_one :target, :through => :forge, :class_name => "User", :source => :user
  
  validates :passed_day, :presence => true
  validates :forge,      :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end
