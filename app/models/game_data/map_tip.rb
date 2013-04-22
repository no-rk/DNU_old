class GameData::MapTip < ActiveRecord::Base
  belongs_to :map
  belongs_to :landform
  attr_accessible :collision, :opacity, :x, :y, :landform_image
  attr_writer :landform_image
  
  has_many :places, :class_name => "Result::Place"
  
  has_many :map_tip_enemy_territories,  :class_name => "GameData::EnemyTerritory"
  has_many :landform_enemy_territories, :through => :landform, :source => :enemy_territories
  has_many :map_enemy_territories,      :through => :map,      :source => :enemy_territories
  
  validates :x,         :numericality => { :only_integer => true, :greater_than => 0 }
  validates :y,         :numericality => { :only_integer => true, :greater_than => 0 }
  validates :landform,  :presence => true
  validates :collision, :inclusion => { :in => [true, false] }
  validates :opacity,   :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  
  before_validation :set_landform
  
  scope :find_by_place, lambda{ |place|
    map_arel = GameData::Map.arel_table
    where(map_arel[:name].eq(place[:name].to_s)).includes(:map).where(:x => place[:x], :y => place[:y])
  }
  
  def enemy_territory
    if map_tip_enemy_territories.where(:map_id => nil, :landform_id => nil).exists?
      map_tip_enemy_territories.where(:map_id => nil, :landform_id => nil).first
    elsif map_enemy_territories.where(:landform_id => landform_id).exists?
      map_enemy_territories.where(:landform_id => landform_id).first
    elsif map_enemy_territories.where(:landform_id => nil).exists?
      map_enemy_territories.where(:landform_id => nil).first
    elsif landform_enemy_territories.where(:map_id => nil).exists?
      landform_enemy_territories.where(:map_id => nil).first
    end
  end
  
  def name
    "#{map.name} #{('A'.ord-1+x).chr}#{y} #{landform.name}"
  end
  
  def landform_image
    @landform_image || landform.try(:image)
  end
  
  def where_places_by_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    places.where(:arrival => true).where(day_arel[:day].eq(day_i)).includes(:day).includes(:user)
  end
  
  def up
    map.map_tips.where(:x=>x-1, :y=>y  ).includes(:map).first
  end
  def right
    map.map_tips.where(:x=>x  , :y=>y+1).includes(:map).first
  end
  def down
    map.map_tips.where(:x=>x+1, :y=>y  ).includes(:map).first
  end
  def left
    map.map_tips.where(:x=>x  , :y=>y-1).includes(:map).first
  end
  def right_up
    map.map_tips.where(:x=>x-1, :y=>y+1).includes(:map).first
  end
  def right_down
    map.map_tips.where(:x=>x+1, :y=>y+1).includes(:map).first
  end
  def left_down
    map.map_tips.where(:x=>x+1, :y=>y-1).includes(:map).first
  end
  def left_up
    map.map_tips.where(:x=>x-1, :y=>y-1).includes(:map).first
  end
  
  private
  def set_landform
    self.landform = GameData::Landform.find_by_image(self.landform_image)
  end
end
