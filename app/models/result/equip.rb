class Result::Equip < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :equip, :class_name => "Register::Equip"
  belongs_to :inventory
  attr_accessible :success
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one :item, :through => :inventory
  
  validates :passed_day, :presence => true
  validates :equip,      :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end