class GameData::Skill < ActiveRecord::Base
  has_many :learning_conditions, :as => :learnable, :dependent => :destroy
  attr_accessible :definition, :name, :tree
  serialize :tree
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.name = definition_tree[:name].to_s
      self.tree = definition_tree
      DNU::Data.set_learning_conditions(self, definition_tree[:learning_conditions])
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
