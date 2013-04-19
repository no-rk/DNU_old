class GameData::Skill < ActiveRecord::Base
  has_many :learning_conditions, :as => :learnable, :dependent => :destroy
  attr_accessible :definition, :name
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      self.name = tree[:name].to_s
      DNU::Data.set_learning_conditions(self, tree[:learning_conditions])
    else
      errors.add(:definition, definition)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
