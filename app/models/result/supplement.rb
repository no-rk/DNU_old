class Result::Supplement < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :supplement, :class_name => "Register::Supplement"
  belongs_to :from,       :class_name => "Result::Item"
  belongs_to :to,         :class_name => "Result::Item"
  belongs_to :item_sup,   :dependent => :destroy
  attr_accessible :success
  
  has_one :user,   :through => :passed_day
  has_one :day,    :through => :passed_day
  has_one :target, :through => :supplement, :class_name => "User", :source => :user
  
  validates :passed_day, :presence => true
  validates :supplement, :presence => true
  validates :success,    :inclusion => { :in => [true, false] }
end
