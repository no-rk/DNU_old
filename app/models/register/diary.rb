class Register::Diary < ActiveRecord::Base
  belongs_to :main
  attr_accessible :diary
  
  validates :diary, :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
end
