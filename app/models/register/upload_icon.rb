class Register::UploadIcon < ActiveRecord::Base
  mount_uploader :icon, IconUploader

  belongs_to :image

  validates :icon   , :presence => true
  validates :name   , :presence => true, :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 400 }

  attr_accessible :icon, :name, :caption, :icon_cache, :remote_icon_url
end
