class GameData::Art < ActiveRecord::Base
  belongs_to :art_type
  has_one :train, :as => :trainable
  attr_accessible :name, :caption, :type, :art_type_id
  
  has_one  :art_effect
  has_many :result_arts, :class_name => "Result::Art"
  
  validates :art_type, :presence => true
  validates :name,     :presence => true, :uniqueness => true
  
  scope :find_all_by_type, lambda{ |art_type_name|
    art_type_arel = GameData::ArtType.arel_table
    where(art_type_arel[:name].eq(art_type_name)).includes(:art_type)
  }
  
  scope :find_by_name, lambda{ |name|
    where(:name => name).includes(:art_type)
  }
  
  scope :find_by_type_and_name, lambda{ |art_type_name,name|
    art_type_arel = GameData::ArtType.arel_table
    where(art_type_arel[:name].eq(art_type_name)).includes(:art_type).where(:name => name)
  }
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def train_point
    @train_point ||= GameData::Point.find_by_use(:art_type_id, self.art_type.id)
  end
  
  def require_point(n)
    n.to_i
  end
  
  def blossom_point(n = nil)
    10
  end
  
  def forget_point(n)
    n.to_i*2
  end
  
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
  def set_game_data
    if GameData::Train.name_exists?(self)
      errors.add(:name, "はすでに訓練可能なものの中に存在します。")
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
    DNU::Data.trainable(self, self.art_type.train)
  end
end
