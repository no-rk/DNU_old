class GameData::BattleValue < ActiveRecord::Base
  attr_accessible :caption, :name, :has_equip_value, :has_max, :min, :max
  
  validates :name,            :presence => true, :uniqueness => true
  validates :has_max,         :inclusion => { :in => [true, false] }
  validates :has_equip_value, :inclusion => { :in => [true, false] }
  
  def self.has_max_and_equip_value(b_max, b_equip)
    self.where(:has_max =>b_max, :has_equip_value => b_equip).pluck(:name) - GameData::Disease.pluck(:name)
  end
end
