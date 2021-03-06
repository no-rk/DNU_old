class GameData::Equip < ActiveRecord::Base
  belongs_to :item_type
  attr_accessible :definition, :kind, :name, :caption, :tree
  serialize :tree
  
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def character_active
  end
  
  def character_passive
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.item_type = GameData::ItemType.find_by_name(definition_tree[:name].to_s)
      self.kind      = definition_tree[:kind].to_s
      self.name      = definition_tree[:name].to_s
      self.caption   = definition_tree[:caption].to_s
      self.tree      = definition_tree
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
