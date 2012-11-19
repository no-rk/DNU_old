class Register::UploadIcon < ActiveRecord::Base
  mount_uploader :icon, IconUploader

  belongs_to :image

  validates :name, :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 400 }

  attr_accessible :icon, :name, :caption
end
