class Result::Notice < ActiveRecord::Base
  belongs_to :battle_type, :class_name => "GameData::BattleType"
  belongs_to :party
  belongs_to :enemy, :class_name => "Result::Party"
  
  has_one :battle, :dependent => :destroy
  
  has_one  :day,           :through => :party
  has_many :party_members, :through => :party
  has_many :enemy_members, :through => :enemy, :class_name => "Result::PartyMember", :source => :party_members
  
  validates :battle_type, :presence => true
  validates :party,       :presence => true
  validates :enemy,       :presence => true
  
  def set_item_skill!(day_i = Day.last_day_i)
    party.set_item_skill!(day_i, battle_type.name)
    enemy.set_item_skill!(day_i, battle_type.name)
  end
  
  def characters(day_i = Day.last_day_i)
    @characters ||= DNU::Fight::State::Characters.new.concat(party.characters(day_i, battle_type.name)).
                                                      concat(enemy.characters(day_i, battle_type.name))
  end
  
  def pt_settings_tree(day_i = Day.last_day_i)
    @pt_settings ||= {
      :settings => party.pt_settings_tree(day_i, battle_type.name)[:settings] +
                   enemy.pt_settings_tree(day_i, battle_type.name)[:settings]
    }
  end
end
