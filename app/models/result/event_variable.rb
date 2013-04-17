class Result::EventVariable < ActiveRecord::Base
  belongs_to :event
  attr_accessible :kind, :name, :value
  
  validates :kind, :inclusion => { :in => ["boolean", "integer", "string"] }
  validates :name, :presence => true
  serialize :value
end
