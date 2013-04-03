class Result::Inventory < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :item
  attr_accessible :number
end
