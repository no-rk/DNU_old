class Register::SendPoint < ActiveRecord::Base
  belongs_to :trade
  belongs_to :point, :class_name => "GameData::Point"
  belongs_to :user
  attr_accessible :point_id, :user_id, :message, :value
  
  has_one :day,    :through => :trade
  has_one :sender, :through => :trade, :source => :user
  
  validates :point_id, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :user_id,  :numericality => { :only_integer => true, :greater_than => 0 }
  validates :value,    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :message, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :message
  
  def character_active
    sender
  end
  
  def character_passive
    user
  end
end
