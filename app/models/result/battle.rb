class Result::Battle < ActiveRecord::Base
  belongs_to :notice
  attr_accessible :tree, :html
  serialize :tree
  
  has_one  :day, :through => :notice
end
