class Result::PetInventory < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :character_type, :class_name => "GameData::CharacterType"
  belongs_to :pet
  attr_accessible :kind, :number
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one  :plan,         :through => :pet
  has_many :pet_names,    :through => :pet
  has_many :pet_statuses, :through => :pet
  has_many :pet_sups,     :through => :pet
  has_many :pet_skills,   :through => :pet
  
  has_one :type, :through => :pet, :class_name => "GameData::ItemType"
  
  has_many :result_equips, :class_name => "Result::Equip"
  
  validates :passed_day,     :presence => true
  validates :character_type, :presence => true
  validates :kind,           :presence => true
  validates :pet,            :presence => true
  validates :number,         :numericality => { :only_integer => true, :greater_than => 0 }
  
  before_validation :set_kind
  
  def pet_name
    pet.pet_name(self.day.day)
  end
  
  def pet_status(n)
    pet.pet_status(n, self.day.day)
  end
  
  def pet_sup(n)
    pet.pet_sup(n, self.day.day)
  end
  
  def pet_skill(n)
    pet.pet_skill(n, self.day.day)
  end
  
  private
  def set_kind
    self.kind = self.character_type.name
  end
end
