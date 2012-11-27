class Register::Icon < ActiveRecord::Base
  belongs_to :character
  belongs_to :upload_icon

  validates :number        , :numericality => { :only_integer => true }, :presence => true
  validates :name          , :length => { :maximum => 20  }
  validates :caption       , :length => { :maximum => 400 }

  attr_accessible :number, :upload_icon_id, :url, :name, :caption

  clean_before_validation :url, :name
  sanitize_before_validation :caption
end
