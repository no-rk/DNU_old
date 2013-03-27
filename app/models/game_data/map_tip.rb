class GameData::MapTip < ActiveRecord::Base
  belongs_to :map
  attr_accessible :collision, :landform, :opacity, :x, :y
end
