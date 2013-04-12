class Result::Learn < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :learnable, :polymorphic => true
  attr_accessible :first
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day, :presence => true
  validates :learnable,  :presence => true
end
