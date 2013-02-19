class Day < ActiveRecord::Base
  attr_accessible :day, :state
  
  def self.updating?
    self.last.try(:state)==0
  end
end
