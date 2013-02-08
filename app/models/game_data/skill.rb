class GameData::Skill < ActiveRecord::Base
  has_many :learning_conditions, :as => :learnable
  has_many :battle_settings,     :as => :usable
  attr_accessible :definition, :name
end
