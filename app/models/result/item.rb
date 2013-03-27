class Result::Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :makable, :polymorphic => true
  belongs_to :item
  attr_accessible :protect
end
