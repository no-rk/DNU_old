class Register::InitGuardian < ActiveRecord::Base
  belongs_to :initial
  belongs_to :guardian, :class_name => "GameData::Guardian"

  validates :guardian, :presence => true

  attr_accessible :guardian_id
end
