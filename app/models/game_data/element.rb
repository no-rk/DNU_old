class GameData::Element < ActiveRecord::Base
  has_many :battle_values, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :battle_values
  attr_accessible :anti, :caption, :color, :name
  
  validates :name,  :presence => true, :uniqueness => true
  validates :color, :length => { :is => 6 }
  validates :anti,  :presence => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def set_game_data
    color = DNU::Data.parse(:color, self.color)
    if color.present?
      self.color = color
      set_battle_values
    else
      errors.add(:color, :invalid)
    end
  end
  
  def set_battle_values
    if self.battle_values.exists?
      ["特性", "耐性"].each_with_index do |v,i|
        self.battle_values[i].name    = "#{self.name}#{v}"
        self.battle_values[i].caption = "#{self.name}の#{v}。"
        self.battle_values[i].min     =  0
      end
    else
      ["特性", "耐性"].each do |v|
        self.battle_values.build do |bv|
          bv.name    = "#{self.name}#{v}"
          bv.caption = "#{self.name}の#{v}。"
          bv.min     =  0
        end
      end
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
