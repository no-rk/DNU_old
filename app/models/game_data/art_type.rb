class GameData::ArtType < ActiveRecord::Base
  has_many :arts
  attr_accessible :name, :caption, :blossom, :forget, :lv_cap, :train
  
  validates :name,    :presence => true, :uniqueness => true
  validates :blossom, :inclusion => { :in => [true, false] }
  validates :forget,  :inclusion => { :in => [true, false] }
  validates :lv_cap,  :inclusion => { :in => [true, false] }
  validates :train,   :inclusion => { :in => [true, false] }
  
  after_save :sync_game_data
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
