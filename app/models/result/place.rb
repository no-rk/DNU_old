class Result::Place < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :map_tip, :class_name => "GameData::MapTip"
  attr_accessible :arrival
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one  :map, :through => :map_tip, :class_name => "GameData::Map"
  
  validates :passed_day, :presence => true
  validates :map_tip,    :presence => true
  validates :arrival,    :inclusion => { :in => [true, false] }
  
  def enemy_territory
    map_tip.enemy_territory
  end
  
  def find_party_slogan_by_day_i(day_i = Day.last_day_i)
    user.register(:main, day_i).try(:party_slogan).try(:slogan)
  end
  
  def name
    map_tip.name
  end
end
