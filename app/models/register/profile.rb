class Register::Profile < ActiveRecord::Base
  belongs_to :character

  validates_presence_of :name, :nickname
  validates_length_of :name, :maximum => Settings.profile.name.max
  validates_length_of :nickname, :maximum => Settings.profile.nickname.max
  validates_length_of :race, :maximum => Settings.profile.race.max
  validates_length_of :gender, :maximum => Settings.profile.gender.max
  validates_length_of :age, :maximum => Settings.profile.age.max
  validates_length_of :introduction, :maximum => Settings.profile.introduction.max

  attr_accessible :age, :gender, :introduction, :name, :nickname, :race
end
