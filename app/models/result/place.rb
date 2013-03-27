class Result::Place < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :map_tip
  # attr_accessible :title, :body
end
