class Result::Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :makable, :polymorphic => true
  belongs_to :item

  has_many :item_strengths
  has_many :item_elements

  attr_accessible :protect
end
