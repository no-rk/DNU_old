class Result::ItemElement < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :makable, :polymorphic => true
  belongs_to :element, :class_name => "GameData::Element"
  # attr_accessible :title, :body
end
