class GameData::Art < ActiveRecord::Base
  belongs_to :art_type
  attr_accessible :name, :caption
end
