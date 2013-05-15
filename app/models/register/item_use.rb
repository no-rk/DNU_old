class Register::ItemUse < ActiveRecord::Base
  belongs_to :main
  attr_accessible :message, :number
  
  validates :number,  :numericality => { :only_integer => true, :greater_than => 0 }
  validates :message, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :message
end
