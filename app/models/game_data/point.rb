class GameData::Point < ActiveRecord::Base
  attr_accessible :caption, :name, :non_negative, :protect, :train
  
  validates :name,         :presence => true, :uniqueness => true
  validates :non_negative, :inclusion => { :in => [true, false] }
  validates :protect,      :inclusion => { :in => [true, false] }
  validates :train,        :allow_nil => true, :inclusion => { :in => ["Status", "Art", "Job", "Product", "Ability"] }, :uniqueness => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def set_game_data
    self.train = nil if self.train.blank?
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
