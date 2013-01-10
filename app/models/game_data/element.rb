class GameData::Element < ActiveRecord::Base
  attr_accessible :anti, :caption, :color, :name
end
