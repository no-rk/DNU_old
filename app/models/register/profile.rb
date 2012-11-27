class Register::Profile < ActiveRecord::Base
  belongs_to :character

  validates :name        , :length => { :maximum => Settings.profile.name.max         }, :presence => true
  validates :nickname    , :length => { :maximum => Settings.profile.nickname.max     }, :presence => true
  validates :race        , :length => { :maximum => Settings.profile.race.max         }
  validates :gender      , :length => { :maximum => Settings.profile.gender.max       }
  validates :age         , :length => { :maximum => Settings.profile.age.max          }
  validates :introduction, :length => { :maximum => Settings.profile.introduction.max }

  attr_accessible :name, :nickname, :race, :gender, :age, :introduction

  clean_before_validation :name, :nickname, :race, :gender, :age
  sanitize_before_validation :introduction
end
