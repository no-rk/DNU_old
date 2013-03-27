class Result::Learn < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :learnable, :polymorphic => true
  attr_accessible :forget
end
