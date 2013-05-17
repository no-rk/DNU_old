class GameData::Landform < ActiveRecord::Base
  attr_accessible :caption, :collision, :color, :image, :name, :opacity
  
  has_many :enemy_territories
  
  validates :name,      :presence => true, :uniqueness => true
  validates :image,     :presence => true, :uniqueness => true
  validates :color,     :length => { :is => 6 }
  validates :collision, :inclusion => { :in => [true, false] }
  validates :opacity,   :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def character_active
  end
  
  def character_passive
  end
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def set_game_data
    color = DNU::Data.parse(:color, self.color)
    if color.present?
      self.color = color
    else
      errors.add(:color, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
