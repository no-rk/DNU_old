class Register::Profile < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  attr_accessible :name, :nickname, :race, :gender, :age, :introduction
  
  validates :name        , :length => { :maximum => Settings.profile.name.maximum         }, :presence => true
  validates :nickname    , :length => { :maximum => Settings.profile.nickname.maximum     }, :presence => true
  validates :race        , :length => { :maximum => Settings.profile.race.maximum         }
  validates :gender      , :length => { :maximum => Settings.profile.gender.maximum       }
  validates :age         , :length => { :maximum => Settings.profile.age.maximum          }
  validates :introduction, :length => { :maximum => Settings.maximum.document, :tokenizer => DNU::Text.counter(:document) }
end
