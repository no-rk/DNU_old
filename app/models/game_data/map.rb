class GameData::Map < ActiveRecord::Base
  has_many :map_tips
  attr_accessible :base, :caption, :name
end
