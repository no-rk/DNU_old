class GameData::Job < ActiveRecord::Base
  has_one :train, :as => :trainable
  attr_accessible :name, :caption
end
