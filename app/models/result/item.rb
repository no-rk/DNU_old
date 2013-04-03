class Result::Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :plan, :polymorphic => true
  belongs_to :type, :polymorphic => true
  belongs_to :source, :class_name => "Result::Item"

  has_many :item_names
  has_many :item_strengths
  has_many :item_elements
  has_many :item_sups

  attr_accessible :protect
end
