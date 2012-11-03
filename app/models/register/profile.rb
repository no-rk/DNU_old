class Register::Profile < ActiveRecord::Base
  belongs_to :character, :polymorphic => true

  validates_presence_of :name, :nickname

  attr_accessible :age, :gender, :introduction, :name, :nickname, :race
end
