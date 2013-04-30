class Register::ItemUse < ActiveRecord::Base
  belongs_to :main
  attr_accessible :message, :number
  
  validates :number,  :numericality => { :only_integer => true, :greater_than => 0 }
  validates :message, :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
end
