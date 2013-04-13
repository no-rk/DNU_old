class Result::ItemStrength < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :source, :class_name => "Result::Item"
  attr_accessible :strength
  
  validates :user,     :presence => true
  validates :day,      :presence => true
  validates :strength, :numericality => { :only_integer => true, :greater_than => 0 }
end
