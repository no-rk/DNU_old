class Result::Battle < ActiveRecord::Base
  belongs_to :notice
  attr_accessible :tree
  serialize :tree
end
