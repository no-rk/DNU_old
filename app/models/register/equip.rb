class Register::Equip < ActiveRecord::Base
  belongs_to :battlable, :polymorphic => true
  attr_accessible :kind, :number
  
  validates :kind,   :inclusion => { :in => ["武器", "頭", "腕", "身体", "装飾"] }
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
end
