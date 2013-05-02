class Result::Forget < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :forgettable, :polymorphic => true
  attr_accessible :success, :lv
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day,  :presence => true
  validates :forgettable, :presence => true
  validates :success,     :inclusion => { :in => [true, false] }
end
