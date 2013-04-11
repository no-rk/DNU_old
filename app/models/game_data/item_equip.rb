class GameData::ItemEquip < ActiveRecord::Base
  belongs_to :item_type
  attr_accessible :definition, :kind
end
