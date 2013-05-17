class Register::MessageUser < ActiveRecord::Base
  belongs_to :message
  belongs_to :parent, :class_name => "Result::Message"
  belongs_to :user
  attr_accessible :body, :user_id
  
  has_one :day,    :through => :message
  has_one :sender, :through => :message, :source => :user
  
  validates :body, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :body
  
  def character_active
    sender
  end
  
  def character_passive
    user
  end
end
