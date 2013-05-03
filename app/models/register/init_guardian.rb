class Register::InitGuardian < ActiveRecord::Base
  belongs_to :initial
  belongs_to :guardian, :class_name => "GameData::Guardian"
  attr_accessible :guardian_id
  
  has_one :train, :through => :guardian, :class_name => "GameData::Train"
  
  validates :guardian, :presence => true
  
  def source
    self.train.trainable
  end
end
