class Register::SkillName < ActiveRecord::Base
  belongs_to :skill
  attr_accessible :caption, :name
  
  validates :name,    :length => { :maximum => Settings.maximum.name, :tokenizer => DNU::Text.counter(:string) }
  validates :caption, :length => { :maximum => Settings.maximum.caption, :tokenizer => DNU::Text.counter(:document) }
  
  dnu_string_html   :name
  dnu_document_html :caption
end
