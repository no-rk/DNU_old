class GameData::ItemType < ActiveRecord::Base
  attr_accessible :caption, :name
  
  has_one :item_equip
end
