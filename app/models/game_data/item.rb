class GameData::Item < ActiveRecord::Base
  attr_accessible :definition, :kind, :name, :tree
  serialize :tree
  
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def item_skill?
    self.tree[:item_skill].present?
  end
  
  def item_skill
    self.tree[:item_skill]
  end
  
  def item_skill_name
    self.tree[:item_skill][:name]
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.kind = definition_tree[:kind].to_s
      self.name = definition_tree[:name].to_s
      self.tree = definition_tree
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
