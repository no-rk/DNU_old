class Register::MessageUser < ActiveRecord::Base
  belongs_to :message
  belongs_to :parent, :class_name => "Result::MessageUser"
  belongs_to :user
  attr_accessible :body, :user_id
  
  has_one :day,    :through => :message
  has_one :sender, :through => :message, :source => :user
  
  validates :user_id, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :body,    :presence => true, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html :body
  
  def character_active
    sender
  end
  
  def character_passive
    user
  end
end
