class GameData::Disease < ActiveRecord::Base
  attr_accessible :caption, :color, :definition, :name
  
  validates :name,       :presence => true, :uniqueness => true
  validates :color,      :presence => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      self.name    = tree[:name].to_s
      self.color   = tree[:color].to_s
      self.caption = tree[:caption].to_s
    else
      errors.add(:definition, definition)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
