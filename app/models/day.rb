class Day < ActiveRecord::Base
  attr_accessible :day, :state
  
  def self.last_day_i
    last_day = self.last
    last_day.try(:day) || 0
  end
  
  def self.toggle_settled_pending
    last_day = self.last
    
    case last_day.try(:state)
    when 1
      last_day.state = 2
    when 2
      last_day.state = 1
    end
    
    last_day.try(:save!)
  end
  
  def self.updating?
    self.last.try(:state)==0
  end
  
  def self.pending?
    self.last.try(:state)==1
  end
  
  def self.settled?
    self.last.try(:state)==2 or self.last.nil?
  end
  
end
