class GameData::EnemyListElement < ActiveRecord::Base
  belongs_to :enemy_list
  belongs_to :character
  attr_accessible :correction, :frequency
  
  has_many :result_party_members, :class_name => "Result::PartyMember", :as => :character
  
  validates :character,  :presence => true
  validates :correction, :numericality => { :only_integer => true }
  validates :frequency,  :numericality => { :greater_than => 0 }
  
  def name
    "#{character.name}#{pp_correction}"
  end
  
  def pp_correction
    if correction>0
      " +#{correction}"
    elsif correction<0
      " #{correction}"
    end
  end
end
