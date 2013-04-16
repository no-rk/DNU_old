class Result::PartyMember < ActiveRecord::Base
  belongs_to :party
  belongs_to :character, :polymorphic => true
  
  validates :character, :presence => true
end