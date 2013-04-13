class Register::SendItem < ActiveRecord::Base
  belongs_to :trade
  belongs_to :user
  attr_accessible :message, :number, :user_id
  
  validates :user_id, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :number,  :numericality => { :only_integer => true, :greater_than => 0 }
  validates :message, :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
end
