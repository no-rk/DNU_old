class GameData::Event < ActiveRecord::Base
  attr_accessible :caption, :kind, :name
  
  has_many :event_steps
  has_many :event_contents, :through => :event_steps
  
  validates :kind, :inclusion => { :in => ["通常", "共通", "内部"] }
  validates :name, :presence => true
end
