class Result::Skill < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :skill, :class_name => "GameData::Skill"
  attr_accessible :caption, :exp, :forget, :name
end
