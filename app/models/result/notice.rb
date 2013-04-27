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
  
  def characters(day_i = Day.last_day_i)
    @characters ||= DNU::Fight::State::Characters.new.concat(party.characters(day_i)).concat(enemy.characters(day_i))
  end
  
  def pt_settings_tree(day_i = Day.last_day_i)
    @pt_settings ||= { :settings => party.pt_settings_tree(day_i)[:settings] + enemy.pt_settings_tree(day_i)[:settings] }
  end
end
