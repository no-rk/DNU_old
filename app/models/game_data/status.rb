class GameData::Status < ActiveRecord::Base
  attr_accessible :definition, :name, :caption
end
