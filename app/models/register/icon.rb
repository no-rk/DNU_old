class Register::Icon < ActiveRecord::Base
  belongs_to :character
  belongs_to :upload_icon
  attr_accessible :number, :upload_icon_id, :url, :name, :caption

  validates :number,  :presence => true, :numericality => { :only_integer => true }
  validates :name,    :length => { :maximum => Settings.maximum.name, :tokenizer => DNU::Text.counter(:string) }
  validates :caption, :length => { :maximum => Settings.maximum.caption, :tokenizer => DNU::Text.counter(:document) }
  
  dnu_string_html   :name
  dnu_document_html :caption
end
