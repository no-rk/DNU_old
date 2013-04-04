class GameData::MapTip < ActiveRecord::Base
  belongs_to :map
  attr_accessible :collision, :landform, :opacity, :x, :y
  
  has_many :places, :class_name => "Result::Place"
  
  def users(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    places.where(:arraival => true).where(day_arel[:day].eq(2)).includes(:day).includes(:user).map{|r| r.user}
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
end
