class GameData::Ability < ActiveRecord::Base
  has_many :learning_conditions, :as => :learnable
  has_one :train, :as => :trainable
  attr_accessible :caption, :definition, :name
end
