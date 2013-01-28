class GameData::Ability < ActiveRecord::Base
  has_many :learning_conditions, :as => :learnable
  attr_accessible :caption, :definition, :name
end
