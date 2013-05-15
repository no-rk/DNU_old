class GameData::BattleType < ActiveRecord::Base
  attr_accessible :caption, :escape, :name, :result, :rob, :normal
  
  validates :name,   :presence => true, :uniqueness => true
  validates :normal, :allow_nil => true, :inclusion => { :in => [true] }, :uniqueness => true
  validates :result, :inclusion => { :in => [true, false] }
  validates :rob,    :inclusion => { :in => [true, false] }
  validates :escape, :inclusion => { :in => [true, false] }
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def self.normal
    where(:normal => true).first
  end
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def set_game_data
    self.normal ||= nil
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
