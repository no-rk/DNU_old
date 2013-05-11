class Register::Profile < ActiveRecord::Base
  belongs_to :character, :polymorphic => true

  validates :name        , :length => { :maximum => Settings.profile.name.maximum         }, :presence => true
  validates :nickname    , :length => { :maximum => Settings.profile.nickname.maximum     }, :presence => true
  validates :race        , :length => { :maximum => Settings.profile.race.maximum         }
  validates :gender      , :length => { :maximum => Settings.profile.gender.maximum       }
  validates :age         , :length => { :maximum => Settings.profile.age.maximum          }
  validates :introduction, :length => { :maximum => Settings.maximum.document, :tokenizer => DNU::Text.counter(:document) }

  attr_accessible :name, :nickname, :race, :gender, :age, :introduction

  clean_before_validation :name, :nickname, :race, :gender, :age
  sanitize_before_validation :introduction
end
