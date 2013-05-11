class Result::Message < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :message
  attr_accessible :html
  
  has_ancestry
end
