class Register::Diary < ActiveRecord::Base
  belongs_to :main
  attr_accessible :diary
  
  validates :diary, :length => { :maximum => Settings.maximum.document, :tokenizer => DNU::Text.counter(:document) }
end
