class Result::ItemStrength < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :makable, :polymorphic => true
  attr_accessible :strength
end
