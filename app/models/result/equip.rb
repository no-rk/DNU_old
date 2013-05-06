class Result::Equip < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :battle_type, :class_name => "GameData::BattleType"
  belongs_to :equip, :class_name => "Register::Equip"
  belongs_to :inventory
  attr_accessible :success
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one :item, :through => :inventory
  
  validates :passed_day,  :presence => true
  validates :battle_type, :presence => true
  validates :equip,       :presence => true
  validates :success,     :inclusion => { :in => [true, false] }
  
  def tree
    @tree ||= {
      :equip => {
        :kind => item.equip_type,
        :name => inventory.type_name,
        :equip_strength => inventory.strength,
        :settings => [
          inventory.item_sup(:A).try(:tree),
          inventory.item_sup(:B).try(:tree),
          inventory.item_sup(:G).try(:tree)
        ].flatten.compact
      }
    }
  end
end
