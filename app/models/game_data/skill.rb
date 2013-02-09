class GameData::Skill < ActiveRecord::Base
  has_many :learning_conditions, :as => :learnable
  attr_accessible :definition, :name
end
