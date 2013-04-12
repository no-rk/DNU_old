class Result::Blossom < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :blossomable, :polymorphic => true
  attr_accessible :success
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day,  :presence => true
  validates :blossomable, :presence => true
  validates :success,     :inclusion => { :in => [true, false] }
end
