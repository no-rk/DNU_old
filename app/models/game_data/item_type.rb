class GameData::ItemType < ActiveRecord::Base
  attr_accessible :caption, :name, :forge
  
  has_one :equip
  
  validates :name,  :presence => true, :uniqueness => true
  validates :forge, :inclusion => { :in => [true, false] }
  
  after_save :sync_game_data
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
