class GameData::CharacterType < ActiveRecord::Base
  attr_accessible :caption, :name, :player
  
  validates :name,   :presence => true, :uniqueness => true
  validates :player, :allow_nil => true, :inclusion => { :in => [true, false] }, :uniqueness => true
end
