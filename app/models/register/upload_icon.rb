class Register::UploadIcon < ActiveRecord::Base
  acts_as_taggable

  mount_uploader :icon, IconUploader

  belongs_to :image

  validates :icon   , :presence => true
  validates :name   , :presence => true, :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 400 }

  attr_accessor :user_tag
  attr_accessible :icon, :name, :caption, :icon_cache, :remote_icon_url, :user_tag
  
  def user_tag
    @user_tag ||= (self.owner_tag_list_on(self.image.user, :tags) if self.image.respond_to?(:user))
  end
end
