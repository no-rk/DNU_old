class Register::InitJob < ActiveRecord::Base
  belongs_to :initial

  validates_presence_of :name

  attr_accessible :name
end
