class GameData::Art < ActiveRecord::Base
  belongs_to :art_type
  has_one :train, :as => :trainable
  attr_accessible :name, :caption, :type
  
  validates :art_type, :presence => true
  validates :name,     :presence => true, :uniqueness => true
  
  after_save :sync_game_data
  
  scope :find_all_by_art_type_name, lambda{ |art_type_name|
    art_type_arel = GameData::ArtType.arel_table
    where(art_type_arel[:name].eq(art_type_name)).includes(:art_type)
  }
  
  def type=(name)
    self.art_type = GameData::ArtType.find_by_name(name)
    @type = name
  end
  
  def type
    @type || self.art_type.try(:name)
  end
  
  def to_sync_hash
    { :type => self.type }.merge(self.attributes.except("id","art_type_id","created_at","updated_at"))
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
    DNU::Data.trainable(self, self.art_type.train)
  end
end
