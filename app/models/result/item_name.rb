class Result::ItemName < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :source, :class_name => "Result::Item"
  attr_accessible :caption, :name
end
