class GameData::Art < ActiveRecord::Base
  belongs_to :art_type
  has_one :train, :as => :trainable
  attr_accessible :name, :caption
end
