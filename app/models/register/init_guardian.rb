class Register::InitGuardian < ActiveRecord::Base
  belongs_to :initial
  belongs_to :guardian, :class_name => "GameData::Guardian"

  validates :guardian_id, :presence => true

  attr_accessible :guardian_id
end
