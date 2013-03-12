class GameData::Status < ActiveRecord::Base
  has_one :train, :as => :trainable
  attr_accessible :definition, :name, :caption
end
