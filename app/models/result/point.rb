class Result::Point < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :point, :class_name => "GameData::Point"
  attr_accessible :value
end
