class GameData::Ability < ActiveRecord::Base
  has_many :ability_definitions, :dependent => :destroy
  has_many :learning_conditions, :as => :learnable, :dependent => :destroy
  has_one :train, :as => :trainable, :dependent => :destroy
  attr_accessible :caption, :definition, :name, :tree
  serialize :tree
  
  has_many :abilities, :class_name => "Result::Ability"
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def used?
    self.abilities.exists?
  end
  
  def unused?
    !used?
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.name    = definition_tree[:name].to_s
      self.caption = definition_tree[:caption].to_s
      self.tree    = definition_tree
      # アビリティ詳細
      if self.unused?
        self.ability_definitions.destroy_all unless self.new_record?
        check_first = true
        definition_tree[:definitions].each do |effect|
          if effect[:pull_down].present?
            if check_first
              self.ability_definitions.build(:kind => :pull_down, :lv => 1, :caption => "無効")
              check_first = false
            end
            self.ability_definitions.build(:kind => :pull_down, :lv => effect[:lv], :caption => effect[:pull_down].to_s)
          else
            self.ability_definitions.build(:kind => :lv,        :lv => effect[:lv], :caption => effect[:caption].to_s)
          end
        end
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
    DNU::Data.trainable(self, true)
  end
end
