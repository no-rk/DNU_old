class GameData::EnemyTerritory < ActiveRecord::Base
  belongs_to :landform
  belongs_to :map
  belongs_to :map_tip
  belongs_to :enemy_list
  attr_accessible :correction, :definition
  
  validates :landform_id, :allow_nil => true, :uniqueness => {:scope => :map_id }
  validates :map_id,      :allow_nil => true, :uniqueness => {:scope => :landform_id }
  validates :map_tip_id,  :allow_nil => true, :uniqueness => true
  validates :enemy_list,  :presence => true
  validates :correction,  :numericality => { :only_integer => true }
  validates :definition,  :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      if definition_tree[:coordinates].present?
        self.map_tip = GameData::MapTip.find_by_place({
          :name => definition_tree[:map_name].to_s,
          :x    => definition_tree[:coordinates][:x].to_i,
          :y    => definition_tree[:coordinates][:y].to_i
        }).first
      else
        self.landform = GameData::Landform.find_by_name(definition_tree[:landform].to_s) if definition_tree[:landform].present?
        self.map      = GameData::Map.find_by_name(definition_tree[:map_name].to_s)      if definition_tree[:map_name].present?
      end
      self.enemy_list = GameData::EnemyList.find_by_name(definition_tree[:name].to_s)
      self.correction = definition_tree[:correction].to_i
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
