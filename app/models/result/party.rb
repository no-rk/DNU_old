class Result::Party < ActiveRecord::Base
  belongs_to :day
  has_many :party_members
  attr_accessible :caption, :kind, :name
end
