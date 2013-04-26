class GameData::ItemType < ActiveRecord::Base
  attr_accessible :caption, :name, :forge
  
  has_one :equip
  
  validates :name,  :presence => true, :uniqueness => true
  validates :forge, :inclusion => { :in => [true, false] }
end
