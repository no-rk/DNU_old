class GameData::Point < ActiveRecord::Base
  attr_accessible :caption, :name, :non_negative, :protect
  
  has_many :point_uses
  
  validates :name,         :presence => true, :uniqueness => true
  validates :non_negative, :inclusion => { :in => [true, false] }
  validates :protect,      :inclusion => { :in => [true, false] }
  
  after_save :sync_game_data
  
  def self.find_by_use(type, val)
    use_arel = GameData::PointUse.arel_table
    self.where(use_arel[type].eq(val)).includes(:point_uses).first
  end
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
