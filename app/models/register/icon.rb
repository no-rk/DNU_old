class Register::Icon < ActiveRecord::Base
  belongs_to :character
  belongs_to :upload_icon

  validates :name, :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 400 }

  attr_accessible :upload_icon_id, :url, :number, :name, :caption
end
