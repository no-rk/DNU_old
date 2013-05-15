class Register::Hunt < ActiveRecord::Base
  belongs_to :productable, :polymorphic => true
  belongs_to :art_effect, :class_name => "GameData::ArtEffect"
  belongs_to :party_member, :class_name => "Result::PartyMember"
  attr_accessible :art_effect_id, :party_member_id, :message
  
  has_one :art, :through => :art_effect, :class_name => "GameData::Art"
  
  validates :art_effect,   :presence => true
  validates :party_member, :presence => true
  validates :message,      :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :message
end
