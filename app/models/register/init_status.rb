class Register::InitStatus < ActiveRecord::Base
  belongs_to :initial
  belongs_to :status, :class_name => "GameData::Status"

  validates_presence_of :status_id, :count

  attr_accessible :status_id, :count
end
