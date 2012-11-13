class Register::InitGuardian < ActiveRecord::Base
  belongs_to :initial
  belongs_to :guardian, :class_name => "GameData::Guardian"

  validates_presence_of :guardian_id

  attr_accessible :guardian_id
end
