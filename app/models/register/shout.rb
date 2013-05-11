class Register::Shout < ActiveRecord::Base
  belongs_to :main
  attr_accessible :message, :volume
  
  has_one :user, :through => :main
  has_one :day,  :through => :main
  
  validates :volume,  :numericality => { :only_integer => true, :greater_than => 0 }
  validates :message, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
end
