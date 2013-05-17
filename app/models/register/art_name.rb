class Register::ArtName < ActiveRecord::Base
  belongs_to :art
  attr_accessible :caption, :name
  
  has_one :user, :through => :art
  
  validates :name,    :length => { :maximum => Settings.maximum.name, :tokenizer => DNU::Text.counter(:string) }
  validates :caption, :length => { :maximum => Settings.maximum.caption, :tokenizer => DNU::Text.counter(:document) }
  
  dnu_string_html   :name
  dnu_document_html :caption
  
  def character_active
    user
  end
  
  def character_passive
    user
  end
end
