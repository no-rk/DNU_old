class Register::InitJob < ActiveRecord::Base
  belongs_to :initial
  belongs_to :job, :class_name => "GameData::Job"

  validates_presence_of :job_id

  attr_accessible :job_id
end
