class GameData::Art < ActiveRecord::Base
  belongs_to :art_type
  has_one :train, :as => :trainable
  attr_accessible :name, :caption, :type, :art_type_id, :kind, :art_effect_attributes
  
  has_one  :art_effect
  has_many :result_arts, :class_name => "Result::Art"
  
  accepts_nested_attributes_for :art_effect, :reject_if => :all_blank
  
  scope :find_all_by_type, lambda{ |art_type_name|
    where(art_type_arel[:name].eq(art_type_name)).includes(:art_type)
  }
  
  scope :productables, lambda{ |type|
    art_effect_arel = GameData::ArtEffect.arel_table
    where(art_effect_arel[:"#{type}able"].eq(true)).includes(:art_effect)
  }
  
  scope :find_by_name, lambda{ |name|
    where(:name => name).includes(:art_type)
  }
  
  scope :find_by_type_and_name, lambda{ |art_type_name,name|
    where(art_type_arel[:name].eq(art_type_name)).includes(:art_type).where(:name => name)
  }
  
  scope :form, lambda{
    where(art_type_arel[:form].eq(true)).includes(:art_type)
  }
  
  validates :art_type, :presence => true
  validates :kind,     :presence => true
  validates :name,     :presence => true, :uniqueness => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def tree
    @tree ||= self.art_effect.try(:tree)
  end
  
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
    self.art_type = GameData::ArtType.where(:name => name).first
    @type = name
  end
  
  def type
    @type || self.art_type.try(:name)
  end
  
  def to_sync_hash
    { :type => self.type }.merge(self.attributes.except("id","art_type_id","kind","created_at","updated_at"))
  end
  
  private
  def set_game_data
    self.kind = self.art_type.try(:name)
    if GameData::Train.name_exists?(self)
      errors.add(:name, "はすでに訓練可能なものの中に存在します。")
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
    DNU::Data.trainable(self, self.art_type.train)
  end
  
  def self.art_type_arel
    @@art_type_arel ||= GameData::ArtType.arel_table
  end
end
