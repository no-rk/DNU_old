class GameData::BattleSetting < ActiveRecord::Base
  attr_accessible :caption, :kind, :name
  
  validates :kind, :inclusion => { :in => ["使用条件", "使用頻度", "対象指定"] }
  validates :name, :presence => true, :uniqueness => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def set_game_data
    skill_condition = DNU::Data.parse(:skill_condition, self.name)
    if skill_condition.blank?
      errors.add(:name, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
