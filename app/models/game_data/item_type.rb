class GameData::ItemType < ActiveRecord::Base
  attr_accessible :caption, :name
  
  has_one :equip
  
  validates :name,  :presence => true, :uniqueness => true
  
  dnu_document_html :caption
  after_save        :sync_game_data
  
  def character_active
  end
  
  def character_passive
  end
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
