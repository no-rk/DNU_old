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
end
