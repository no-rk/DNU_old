class GameData::ArtType < ActiveRecord::Base
  has_many :arts
  attr_accessible :name, :caption, :blossom, :forget, :lv_cap
end
