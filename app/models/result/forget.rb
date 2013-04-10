class Result::Forget < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :forgettable, :polymorphic => true
  attr_accessible :success
end
