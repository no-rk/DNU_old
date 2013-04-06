class Register::SendPoint < ActiveRecord::Base
  belongs_to :trade
  belongs_to :point, :class_name => "GameData::Point"
  belongs_to :user
  attr_accessible :point_id, :user_id, :message, :value
  
  validates :point_id, :presence => true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :user_id,  :presence => true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :value,    :presence => true, :numericality => { :only_integer => true, :greater_than => 0 }
end
