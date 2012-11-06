class Register::Initial < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_one :init_job, :dependent => :destroy
  accepts_nested_attributes_for :init_job, :allow_destroy => true

  attr_accessible :init_job_attributes
end
