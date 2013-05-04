class Result::PetArt < ActiveRecord::Base
  belongs_to :pet
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :art, :class_name => "GameData::Art"
  belongs_to :source, :class_name => "Result::Pet"
  attr_accessible :lv, :number
  
  validates :user,   :presence => true
  validates :day,    :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :art,    :presence => true
end
