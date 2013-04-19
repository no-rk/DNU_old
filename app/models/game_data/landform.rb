class GameData::Landform < ActiveRecord::Base
  attr_accessible :caption, :collision, :color, :image, :name, :opacity
end
