class Register::Move < ActiveRecord::Base
  belongs_to :main
  attr_accessible :direction
  
  validates :direction, :inclusion => { :in => 0..4 }
end
