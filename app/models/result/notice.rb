class Result::Notice < ActiveRecord::Base
  belongs_to :party
  belongs_to :enemy, :class_name => "Result::Party"
  attr_accessible :kind
  
  has_one :day, :through => :party
end
