class GameData::Point < ActiveRecord::Base
  attr_accessible :caption, :name, :non_negative, :protect
  
  validates :name,         :presence => true, :uniqueness => true
  validates :non_negative, :inclusion => { :in => [true, false] }
  validates :protect,      :inclusion => { :in => [true, false] }
end
