class GameData::Disease < ActiveRecord::Base
  attr_accessible :caption, :color, :definition, :name
end
