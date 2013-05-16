class Register::SendItem < ActiveRecord::Base
  belongs_to :trade
  belongs_to :user
  attr_accessible :message, :number, :user_id
  
  has_one :day,    :through => :trade
  has_one :sender, :through => :trade, :source => :user
  
  validates :user_id, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :number,  :numericality => { :only_integer => true, :greater_than => 0 }
  validates :message, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :message
end
