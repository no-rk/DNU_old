class Register::MessageUser < ActiveRecord::Base
  belongs_to :message
  belongs_to :parent, :class_name => "Result::Message"
  belongs_to :user
  attr_accessible :body, :user_id
  
  validates :body, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :body
end
