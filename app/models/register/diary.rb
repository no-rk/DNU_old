class Register::Diary < ActiveRecord::Base
  belongs_to :main
  attr_accessible :diary
  
  has_one :user, :through => :main
  has_one :day,  :through => :main
  
  validates :diary, :length => { :maximum => Settings.maximum.document, :tokenizer => DNU::Text.counter(:document) }
  
  dnu_document_html :diary
  
  def character_active
    user
  end
  
  def character_passive
    user
  end
end
