class Register::InitGuardian < ActiveRecord::Base
  belongs_to :initial
  belongs_to :guardian, :class_name => "GameData::Guardian"
  
  has_one :art, :through => :guardian, :class_name => "GameData::Art"
  
  validates :guardian, :presence => true
  
  attr_accessible :guardian_id
end
