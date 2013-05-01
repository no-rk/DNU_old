class GameData::Guardian < ActiveRecord::Base
  belongs_to :art, :class_name => "GameData::Art"
  attr_accessible :name, :caption, :art_name, :art_id
  
  validates :art , :presence => true
  validates :name, :presence => true, :uniqueness => true
  
  after_save :sync_game_data
  
  def art_name=(name)
    self.art = GameData::Art.find_by_name(name).first
    @art_name = name
  end
  
  def art_name
    @art_name || self.art.try(:name)
  end
  
  def to_sync_hash
    { :art_name => self.art_name }.merge(self.attributes.except("id","art_id","created_at","updated_at"))
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
