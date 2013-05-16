class Register::Dispose < ActiveRecord::Base
  belongs_to :main
  attr_accessible :number
  
  has_one :day,  :through => :main
  has_one :user, :through => :main
  
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
end
