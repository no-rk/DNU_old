class Result::Notice < ActiveRecord::Base
  belongs_to :party
  belongs_to :day
  belongs_to :enemy, :class_name => "Party"
  attr_accessible :kind
end
