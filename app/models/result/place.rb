class Result::Place < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :map_tip, :class_name => "GameData::MapTip"
  attr_accessible :arrival
  
  has_one :map, :through => :map_tip, :class_name => "GameData::Map"
  
  def name
    "#{map.name} #{('A'.ord-1+map_tip.x).chr}#{map_tip.y} #{I18n.t(map_tip.landform, :scope => 'DNU.Result.Place')}"
  end
end
