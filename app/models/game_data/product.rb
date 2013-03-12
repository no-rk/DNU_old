class GameData::Product < ActiveRecord::Base
  has_one :train, :as => :trainable
  attr_accessible :caption, :name
end
