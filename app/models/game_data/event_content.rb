class GameData::EventContent < ActiveRecord::Base
  belongs_to :event_step
  attr_accessible :content, :kind
  
  has_one   :event, :through => :event_step
  serialize :content
end
