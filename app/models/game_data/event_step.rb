class GameData::EventStep < ActiveRecord::Base
  belongs_to :event
  attr_accessible :condition, :timing, :name
  serialize :condition
  
  has_many :event_contents, :dependent => :destroy
  
  def nickname
    @nickname ||= (name || event.name)
  end
end
