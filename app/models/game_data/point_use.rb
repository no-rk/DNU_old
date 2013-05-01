class GameData::PointUse < ActiveRecord::Base
  belongs_to :point
  belongs_to :art_type
  attr_accessible :status, :name, :type, :point_id, :art_type_id
  
  validates :point,       :presence => true
  validates :status,      :allow_nil => true, :inclusion => { :in => [true, false] }, :uniqueness => true
  validates :art_type_id, :allow_nil => true, :uniqueness => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def name=(name)
    self.point = GameData::Point.find_by_name(name)
    @name = name
  end
  
  def name
    @name || self.point.try(:name)
  end
  
  def type=(name)
    self.art_type = GameData::ArtType.find_by_name(name)
    @type = name
  end
  
  def type
    @type || self.art_type.try(:name)
  end
  
  def to_sync_hash
    { :name => self.name }.merge(self.attributes.except("id","point_id","art_type_id","created_at","updated_at")).merge({ :type => self.type })
  end
  
  private
  def set_game_data
    self.status ||= nil
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
