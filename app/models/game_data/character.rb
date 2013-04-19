class GameData::Character < ActiveRecord::Base
  attr_accessible :definition, :kind, :name
  
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      self.kind = tree[:kind].to_s
      self.name = tree[:name].to_s
    else
      errors.add(:definition, definition)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
