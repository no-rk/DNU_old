class Result::ItemSup < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :makable, :polymorphic => true
  belongs_to :sup, :class_name => "GameData::Sup"
  belongs_to :source, :class_name => "Result::Item"
  attr_accessible :kind
end
