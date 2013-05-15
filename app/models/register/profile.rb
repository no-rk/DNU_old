class Register::Profile < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  attr_accessible :name, :nickname, :race, :gender, :age, :introduction
  
  validates :name        , :length => { :maximum => Settings.profile.name.maximum, :tokenizer => DNU::Text.counter(:string) }, :presence => true
  validates :nickname    , :length => { :maximum => Settings.profile.nickname.maximum, :tokenizer => DNU::Text.counter(:string) }, :presence => true
  validates :race        , :length => { :maximum => Settings.profile.race.maximum, :tokenizer => DNU::Text.counter(:string) }
  validates :gender      , :length => { :maximum => Settings.profile.gender.maximum, :tokenizer => DNU::Text.counter(:string) }
  validates :age         , :length => { :maximum => Settings.profile.age.maximum, :tokenizer => DNU::Text.counter(:string) }
  validates :introduction, :length => { :maximum => Settings.maximum.document, :tokenizer => DNU::Text.counter(:document) }
  
  dnu_string_html   :name
  dnu_string_html   :nickname
  dnu_string_html   :race
  dnu_string_html   :gender
  dnu_string_html   :age
  dnu_document_html :introduction
end
