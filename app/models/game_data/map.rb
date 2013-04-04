class GameData::Map < ActiveRecord::Base
  has_many :map_tips
  attr_accessible :base, :caption, :name
  
  has_many :places, :through => :map_tips, :class_name => "Result::Place"
end
