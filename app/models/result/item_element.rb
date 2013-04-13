class Result::ItemElement < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :element, :class_name => "GameData::Element"
  belongs_to :source, :class_name => "Result::Item"
  
  validates :user,    :presence => true
  validates :day,     :presence => true
  validates :element, :presence => true
end
