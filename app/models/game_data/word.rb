class GameData::Word < ActiveRecord::Base
  attr_accessible :caption, :name
end
