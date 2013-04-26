class Result::Notice < ActiveRecord::Base
  belongs_to :party
  belongs_to :enemy, :class_name => "Result::Party"
  attr_accessible :kind
  
  has_one :battle, :dependent => :destroy
  
  has_one  :day,           :through => :party
  has_many :party_members, :through => :party
  has_many :enemy_members, :through => :enemy, :class_name => "Result::PartyMember", :source => :party_members
  
  validates :party, :presence => true
  validates :kind,  :inclusion => { :in => ["battle"] }
  validates :enemy, :presence => true
  
  def characters
    @characters ||= DNU::Fight::State::Characters.new.concat(party.characters).concat(enemy.characters)
  end
end
