class GameData::EventStep < ActiveRecord::Base
  belongs_to :event
  attr_accessible :condition, :timing
  
  has_many :event_contents
  
  validates :timing,    :inclusion => { :in => ["before_move", "each_move", "after_move"] }
  serialize :condition, Hash
end
