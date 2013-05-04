class Result::CatchPet < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :catch_pet, :class_name => "Register::CatchPet"
  belongs_to :pet,       :class_name => "Result::Pet"
  attr_accessible :number, :success
  
  has_one :user,          :through => :passed_day
  has_one :day,           :through => :passed_day
  
  has_one :character,     :through => :catch_pet
  has_one :event_content, :through => :catch_pet
  
  validates :passed_day, :presence => true
  validates :catch_pet,  :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end
