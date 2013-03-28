class Register::PartySlogan < ActiveRecord::Base
  belongs_to :main

  validates :slogan, :length => { :maximum => Settings.party_slogan.slogan.maximum }

  attr_accessible :kind, :slogan
end
