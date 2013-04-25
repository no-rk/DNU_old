class GameData::Character < ActiveRecord::Base
  attr_accessible :definition, :kind, :name
  
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def tree
    @tree ||= DNU::Data.parse_from_model(self)
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.kind = definition_tree[:kind].to_s
      self.name = definition_tree[:name].to_s
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
