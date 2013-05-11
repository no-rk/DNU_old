class Register::ArtName < ActiveRecord::Base
  belongs_to :art
  attr_accessible :caption, :name
  
  validates :name,    :length => { :maximum => Settings.maximum.name }
  validates :caption, :length => { :maximum => Settings.maximum.caption, :tokenizer => DNU::Text.counter(:document) }
end
