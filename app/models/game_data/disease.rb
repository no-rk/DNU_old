class GameData::Disease < ActiveRecord::Base
  has_many :battle_values, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :battle_values
  attr_accessible :caption, :color, :definition, :name, :tree
  serialize :tree
  
  validates :name,       :presence => true, :uniqueness => true
  validates :color,      :presence => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.name    = definition_tree[:name].to_s
      self.color   = definition_tree[:color].to_s
      self.caption = definition_tree[:caption].to_s
      self.tree    = definition_tree
      set_battle_values
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def set_battle_values
    if self.battle_values.exists?
      self.battle_values[0].name    = self.name
      self.battle_values[0].caption = "#{self.name}の深度。"
      self.battle_values[0].min     = 0
      self.battle_values[0].max     = 20
      ["特性", "耐性"].each_with_index do |v,i|
        self.battle_values[i+1].name    = "#{self.name}#{v}"
        self.battle_values[i+1].caption = "#{self.name}の#{v}。"
        self.battle_values[i+1].min     = 0
        self.battle_values[i+1].max     = nil
      end
    else
      self.battle_values.build do |bv|
        bv.name    = self.name
        bv.caption = "#{self.name}の深度。"
        bv.min     = 0
        bv.max     = 20
      end
      ["特性", "耐性"].each do |v|
        self.battle_values.build do |bv|
          bv.name    = "#{self.name}#{v}"
          bv.caption = "#{self.name}の#{v}。"
          bv.min     = 0
          bv.max     = nil
        end
      end
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
