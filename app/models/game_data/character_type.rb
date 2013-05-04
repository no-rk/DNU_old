class GameData::CharacterType < ActiveRecord::Base
  belongs_to :equip
  attr_accessible :caption, :name, :player, :equip_name
  
  validates :name,   :presence => true, :uniqueness => true
  validates :player, :allow_nil => true, :inclusion => { :in => [true, false] }, :uniqueness => true
  
  after_save :sync_game_data
  
  def equip_name=(name)
    self.equip = GameData::Equip.where(:name => name).first
    @equip_name = name
  end
  
  def equip_name
    @equip_name || self.equip.try(:name)
  end
  
  def to_sync_hash
    self.attributes.except("id","equip_id","created_at","updated_at").merge(:equip_name => self.equip_name)
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
