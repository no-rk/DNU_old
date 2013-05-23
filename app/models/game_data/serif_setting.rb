class GameData::SerifSetting < ActiveRecord::Base
  attr_accessible :caption, :condition, :kind, :name
  
  validates :kind, :inclusion => { :in => ["発言条件"] }
  validates :name, :presence => true, :uniqueness => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def character_active
  end
  
  def character_passive
  end
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def set_game_data
    serif_condition = DNU::Data.parse(:serif_condition, self.condition)
    if serif_condition.blank?
      errors.add(:condition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
