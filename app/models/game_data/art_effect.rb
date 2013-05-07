class GameData::ArtEffect < ActiveRecord::Base
  belongs_to :art
  has_many :learning_conditions, :as => :learnable, :dependent => :destroy
  attr_accessible :definition, :art_id, :art_name
  serialize :tree
  
  has_many :result_arts, :through => :art
  has_many :days,        :through => :result_arts
  
  validates :art,            :presence => true
  validates :art_id,         :uniqueness => true
  validates :kind,           :presence => true
  validates :name,           :presence => true, :uniqueness => true
  validates :lv_effect,      :inclusion => { :in => [true, false] }
  validates :pull_down,      :inclusion => { :in => [true, false] }
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
  
  def art_name=(name)
    self.art = GameData::Art.where(:name => name).first
    @art_name = name
  end
  
  def art_name
    @art_name || self.art.try(:name)
  end
  
  def to_sync_hash
    { :art_name => self.art_name, :definition => self.attributes["definition"] }
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      if self.unused?
        self.kind           = self.art.try(:type)
        self.name           = self.art.try(:name)
        self.lv_effect      = definition_tree[:definitions].any?{|h| h[:pull_down].blank?}
        self.pull_down      = definition_tree[:definitions].any?{|h| h[:pull_down].present?}
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
