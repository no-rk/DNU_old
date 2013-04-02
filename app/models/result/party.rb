class Result::Party < ActiveRecord::Base
  belongs_to :day
  has_many :party_members
  has_many :notices
  attr_accessible :caption, :kind, :name
end
