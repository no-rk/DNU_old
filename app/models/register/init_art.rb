class Register::InitArt < ActiveRecord::Base
  belongs_to :initial
  belongs_to :art, :class_name => "GameData::Art"

  validates :art, :presence => true

  attr_accessible :art_id
end
