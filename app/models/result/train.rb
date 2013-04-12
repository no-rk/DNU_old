class Result::Train < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :trainable, :polymorphic => true
  attr_accessible :from, :success, :to
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day, :presence => true
  validates :trainable,  :presence => true
  validates :from,       :presence => true
  validates :to,         :presence => true
end
