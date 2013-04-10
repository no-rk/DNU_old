class Result::Train < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :trainable, :polymorphic => true
  attr_accessible :from, :success, :to
end
