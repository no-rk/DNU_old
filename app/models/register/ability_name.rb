class Register::AbilityName < ActiveRecord::Base
  belongs_to :ability_conf
  attr_accessible :caption, :name
  
  validates :name,    :length => { :maximum => 4 }
  validates :caption, :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
end
