class GameData::AbilityDefinition < ActiveRecord::Base
  belongs_to :ability
  attr_accessible :caption, :lv, :kind
end
