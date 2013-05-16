class Register::Equip < ActiveRecord::Base
  belongs_to :battlable, :polymorphic => true
  attr_accessible :kind, :number
  
  validates :kind,   :inclusion => { :in => GameData::EquipType.pluck(:name) }
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
  
  def user
    self.battlable.try:user
  end
  
  def day
    self.battlable.try:day
  end
end
