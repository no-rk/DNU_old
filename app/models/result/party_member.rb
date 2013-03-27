class Result::PartyMember < ActiveRecord::Base
  belongs_to :party
  belongs_to :character, :polymorphic => true
  # attr_accessible :title, :body
end
