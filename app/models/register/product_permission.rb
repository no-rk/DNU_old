class Register::ProductPermission < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  attr_accessible :user_id
  
  has_one :day, :through => :product
  
  validates :user_id, :numericality => { :only_integer => true, :greater_than => 0 }
end
