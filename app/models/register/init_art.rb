class Register::InitArt < ActiveRecord::Base
  belongs_to :initial
  belongs_to :art, :class_name => "GameData::Art"

  validates_presence_of :art_id

  attr_accessible :art_id
end
