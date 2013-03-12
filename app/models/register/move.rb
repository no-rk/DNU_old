class Register::Move < ActiveRecord::Base
  belongs_to :main

  validates :direction, :inclusion => { :in => 0..4 }

  attr_accessible :direction
end
