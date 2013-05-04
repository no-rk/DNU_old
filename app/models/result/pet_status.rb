class Result::PetStatus < ActiveRecord::Base
  belongs_to :pet
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :status, :class_name => "GameData::Status"
  belongs_to :source, :class_name => "Result::Pet"
  attr_accessible :bonus, :count
  
  validates :user,   :presence => true
  validates :day,    :presence => true
  validates :status, :presence => true
  validates :count,  :numericality => { :only_integer => true, :greater_than_or_euql_to => 0 }
  validates :bonus,  :numericality => { :only_integer => true, :greater_than_or_euql_to => 0 }
  
  def value(n = count)
    ((1.0/4)*(n+10)*(n+20)).ceil
  end
end
