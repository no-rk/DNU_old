class GameData::Character < ActiveRecord::Base
  attr_accessible :definition, :kind, :name
end
