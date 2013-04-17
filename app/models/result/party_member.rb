class Result::PartyMember < ActiveRecord::Base
  belongs_to :party
  belongs_to :character, :polymorphic => true
  
  has_one :day, :through => :party
  
  validates :character, :presence => true
end