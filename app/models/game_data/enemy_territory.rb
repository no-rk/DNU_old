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
    tree = DNU::Data.parse(self)
    if tree.present?
      if tree[:coordinates].present?
        self.map_tip = GameData::MapTip.find_by_place({
          :name => tree[:map_name].to_s,
          :x    => tree[:coordinates][:x].to_i,
          :y    => tree[:coordinates][:y].to_i
        }).first
      else
        self.landform = GameData::Landform.find_by_name(tree[:landform].to_s) if tree[:landform].present?
        self.map      = GameData::Map.find_by_name(tree[:map_name].to_s)      if tree[:map_name].present?
      end
      self.enemy_list = GameData::EnemyList.find_by_name(tree[:name].to_s)
      self.correction = tree[:correction].nil? ? 0 : "#{tree[:correction][:minus].present? ? '-' : '+'}#{tree[:correction][:value]}".to_i
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
