class GameData::Item < ActiveRecord::Base
  attr_accessible :definition, :kind, :name
end
