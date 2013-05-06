class GameData::ArtEffect < ActiveRecord::Base
  belongs_to :art
  has_many :learning_conditions, :as => :learnable, :dependent => :destroy
  attr_accessible :caption, :definition, :name, :tree, :kind, :forgeable, :supplementable, :huntable
  serialize :tree
  
  has_many :result_arts, :through => :art
  has_many :days,        :through => :result_arts
  
  validates :art,            :presence => true
  validates :art_id,         :uniqueness => true
  validates :kind,           :presence => true
  validates :name,           :presence => true, :uniqueness => true
  validates :forgeable,      :inclusion => { :in => [true, false] }
  validates :supplementable, :inclusion => { :in => [true, false] }
  validates :huntable,       :inclusion => { :in => [true, false] }
  validates :definition,     :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def forgeable_item_types
    (self.tree[:forgeable_item_types] || []).each.with_index.inject({}){|h,(v,i)| h.tap{ h[v] = i.to_i } }
  end
  
  def battle?
    tree[:effects].present? or tree[:definitions].present?
  end
  
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
        self.art            = GameData::Art.find_by_type_and_name(definition_tree[:kind], definition_tree[:name]).first
        self.kind           = definition_tree[:kind]
        self.name           = definition_tree[:name]
        self.forgeable      = definition_tree[:forgeable_item_types].present?
        self.supplementable = definition_tree[:supplementable_equip_types].present?
        self.huntable       = definition_tree[:huntable_character_types].present?
        self.tree           = definition_tree
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
