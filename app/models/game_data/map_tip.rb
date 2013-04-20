class GameData::MapTip < ActiveRecord::Base
  belongs_to :map
  belongs_to :landform
  attr_accessible :collision, :opacity, :x, :y, :landform_image
  attr_writer :landform_image
  
  has_many :places, :class_name => "Result::Place"
  
  validates :x,         :numericality => { :only_integer => true, :greater_than => 0 }
  validates :y,         :numericality => { :only_integer => true, :greater_than => 0 }
  validates :landform,  :presence => true
  validates :collision, :inclusion => { :in => [true, false] }
  validates :opacity,   :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  
  before_validation :set_landform
  
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
