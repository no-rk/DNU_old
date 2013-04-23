class GameData::BattleValue < ActiveRecord::Base
  attr_accessible :caption, :name, :has_equip_value, :only_caption, :has_max
  
  validates :name,            :presence => true, :uniqueness => true
  validates :only_caption,    :inclusion => { :in => [true, false] }
  validates :has_max,         :inclusion => { :in => [true, false] }
  validates :has_equip_value, :inclusion => { :in => [true, false] }
  
  def self.has_max_and_equip_value(b_max, b_equip)
    battle_values = self.where(:only_caption => false, :has_max =>b_max, :has_equip_value => b_equip).pluck(:name).map{|name| name }
    
    if !b_max and b_equip
      battle_values += GameData::Disease.pluck(:name).map{|name| ["#{name}特性", "#{name}耐性"] }.flatten +
                       GameData::Element.pluck(:name).map{|name| ["#{name}特性", "#{name}耐性"] }.flatten
    end
    
    battle_values
  end
end
