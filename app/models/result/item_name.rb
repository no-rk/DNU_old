class Result::ItemName < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :source, :class_name => "Result::Item"
  attr_accessible :caption, :name
  
  validates :user,    :presence => true
  validates :day,     :presence => true
  validates :name,    :presence => true, :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 800 }
end
