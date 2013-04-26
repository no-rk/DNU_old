class GameData::Status < ActiveRecord::Base
  has_one :train, :as => :trainable, :dependent => :destroy
  attr_accessible :definition, :name, :caption, :tree
  serialize :tree
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.name    = definition_tree[:name].to_s
      self.caption = definition_tree[:caption].to_s
      self.tree    = definition_tree
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
    DNU::Data.trainable(self, true)
  end
end
