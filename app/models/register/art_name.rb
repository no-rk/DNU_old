class Register::ArtName < ActiveRecord::Base
  belongs_to :art
  attr_accessible :caption, :name
  
  validates :name,    :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
end
