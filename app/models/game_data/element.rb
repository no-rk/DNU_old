class GameData::Element < ActiveRecord::Base
  attr_accessible :anti, :caption, :color, :name
  
  after_save :sync_game_data
  
  private
  def sync_game_data
    battle_value
  end
  
  def battle_value
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
