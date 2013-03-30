class GameData::Point < ActiveRecord::Base
  attr_accessible :caption, :name, :non_negative, :protect
end
