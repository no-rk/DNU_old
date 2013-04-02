class Result::Status < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :status, :class_name => "GameData::Status"
  attr_accessible :bonus, :caption, :count, :name
end
