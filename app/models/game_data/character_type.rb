class GameData::CharacterType < ActiveRecord::Base
  attr_accessible :caption, :name, :player
  
  validates :name,   :presence => true, :uniqueness => true
  validates :player, :allow_nil => true, :inclusion => { :in => [true, false] }, :uniqueness => true
  
  after_save :sync_game_data
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
