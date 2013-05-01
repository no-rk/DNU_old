class GameData::ArtEffect < ActiveRecord::Base
  belongs_to :art
  has_many :learning_conditions, :as => :learnable, :dependent => :destroy
  attr_accessible :caption, :definition, :name, :tree, :kind
  serialize :tree
  
  has_many :result_arts, :through => :art
  has_many :days,        :through => :result_arts
  
  validates :art,        :presence => true
  validates :art_id,     :uniqueness => true
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def used?
    self.result_arts.exists?
  end
  
  def unused?
    !used?
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      if self.unused?
        self.art  = GameData::Art.find_by_type_and_name(definition_tree[:kind], definition_tree[:name]).first
        self.kind = definition_tree[:kind]
        self.name = definition_tree[:name]
        self.tree = definition_tree
        DNU::Data.set_learning_conditions(self, definition_tree[:learning_conditions])
      else
        errors[:base] << "使用中の#{self.class.model_name.human}のため編集できません。"
      end
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
