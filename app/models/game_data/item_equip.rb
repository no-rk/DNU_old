class GameData::ItemEquip < ActiveRecord::Base
  belongs_to :item_type
  attr_accessible :definition, :kind
  
  validates :kind, :inclusion => { :in => ["武器", "頭", "腕", "身体", "装飾"] }
end
