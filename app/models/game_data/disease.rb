class GameData::Disease < ActiveRecord::Base
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
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
    battle_value
  end
  
  def battle_value
    bv = GameData::BattleValue.where(:name => self.name).first_or_initialize
    
    bv.caption         = "#{self.name}の深度。"
    bv.min             =  0
    bv.max             = 20
    bv.has_max         = false
    bv.has_equip_value = false
    bv.save!
    ["特性", "耐性"].each do |v|
      bv = GameData::BattleValue.where(:name => "#{self.name}#{v}").first_or_initialize
      
      bv.caption         = "#{self.name}の#{v}。"
      bv.min             =  0
      bv.has_max         = false
      bv.has_equip_value = false
      bv.save!
    end
  end
end
