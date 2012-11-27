class Register::InitJob < ActiveRecord::Base
  belongs_to :initial
  belongs_to :job, :class_name => "GameData::Job"

  validates :job_id, :presence => true

  attr_accessible :job_id
end
