class Result::Map < ActiveRecord::Base
  belongs_to :day
  belongs_to :map, :class_name => "GameData::Map"
  has_many :map_tips, :through => :map, :class_name => "GameData::MapTip"
  attr_accessible :image
  
  scope :find_by_name_and_day_i, lambda{ |name, day_i|
    day_arel = Day.arel_table
    map_arel = GameData::Map.arel_table
    
    where(map_arel[:name].eq(name)).includes(:map).
    where(day_arel[:day].eq(day_i)).includes(:day)
  }
  
  def user_counts
    map_arel = GameData::MapTip.arel_table
    day_arel = Day.arel_table
    Result::Place.where(:arrival => true).where(day_arel[:day].eq(day.day)).includes(:day).where(map_arel[:map_id].eq(map.id)).includes(:map_tip).group(:x,:y).count
  end
end
