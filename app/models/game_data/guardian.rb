class GameData::Guardian < ActiveRecord::Base
  belongs_to :train, :class_name => "GameData::Train"
  attr_accessible :name, :caption, :source_name, :train_id
  
  validates :train, :presence => true
  validates :name,  :presence => true, :uniqueness => true
  
  after_save :sync_game_data
  
  def source
    self.train.trainable
  end
  
  def source_name=(name)
    self.train = GameData::Train.find_by_name(name)
    @source_name = name
  end
  
  def source_name
    @source_name || self.train.try(:name)
  end
  
  def to_sync_hash
    { :source_name => self.source_name }.merge(self.attributes.except("id","train_id","created_at","updated_at"))
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
