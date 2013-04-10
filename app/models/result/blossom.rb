class Result::Blossom < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :blossomable, :polymorphic => true
  attr_accessible :success
end
