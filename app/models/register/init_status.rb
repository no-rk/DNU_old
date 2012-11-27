class Register::InitStatus < ActiveRecord::Base
  belongs_to :initial
  belongs_to :status, :class_name => "GameData::Status"

  validates :status_id, :presence => true, :numericality => { :only_integer => true }
  validates :count    , :presence => true, :numericality => { :only_integer => true }

  attr_accessible :status_id, :count
end
