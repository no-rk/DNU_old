class Register::Dispose < ActiveRecord::Base
  belongs_to :main
  attr_accessible :number
  
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
end
