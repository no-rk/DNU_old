class GameData::CharacterType < ActiveRecord::Base
  belongs_to :equip
  attr_accessible :caption, :name, :player, :equip_id, :equip_name
  
  validates :name,   :presence => true, :uniqueness => true
  validates :player, :allow_nil => true, :inclusion => { :in => [true] }, :uniqueness => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def character_active
  end
  
  def character_passive
  end
  
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
  def set_game_data
    self.player ||= nil
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
