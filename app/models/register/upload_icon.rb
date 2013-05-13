class Register::UploadIcon < ActiveRecord::Base
  belongs_to :image
  attr_accessible :icon, :name, :caption, :icon_cache, :remote_icon_url, :user_tag
  attr_accessor :user_tag
  
  acts_as_taggable
  mount_uploader :icon, IconUploader
  
  validates :icon   , :presence => true
  validates :name   , :presence => true, :length => { :maximum => Settings.maximum.name  }
  validates :caption, :length => { :maximum => Settings.maximum.caption, :tokenizer => DNU::Text.counter(:document) }
  
  scope :where_public, lambda{
    taggings = ActsAsTaggableOn::Tagging.arel_table
    where(taggings[:tagger_type].eq("User")).includes(:tag_taggings,:image=>[:user=>[:character=>:profile]])
  }
  
  def user_tag
    @user_tag ||= (self.owner_tag_list_on(self.image.user, :tags) if self.image.respond_to?(:user))
  end
end
