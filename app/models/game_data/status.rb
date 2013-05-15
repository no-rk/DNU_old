class GameData::Status < ActiveRecord::Base
  has_one :train, :as => :trainable, :dependent => :destroy
  attr_accessible :definition, :name, :caption, :tree
  serialize :tree
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  dnu_document_html :caption
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def train_point
    @train_point ||= GameData::Point.find_by_use(:status, true)
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.name    = definition_tree[:name].to_s
      self.caption = definition_tree[:caption].to_s
      self.tree    = definition_tree
      if GameData::Train.name_exists?(self)
        errors.add(:name, "はすでに訓練可能なものの中に存在します。")
      end
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
    DNU::Data.trainable(self, true)
  end
end
