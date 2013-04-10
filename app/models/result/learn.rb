class Result::Learn < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :learnable, :polymorphic => true
  attr_accessible :first
end
