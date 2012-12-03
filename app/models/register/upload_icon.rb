class Register::UploadIcon < ActiveRecord::Base
  acts_as_taggable

  mount_uploader :icon, IconUploader

  belongs_to :image

  validates :icon   , :presence => true
  validates :name   , :length => { :maximum => 20  }, :presence => true
  validates :caption, :length => { :maximum => 400, :tokenizer => DNU::Sanitize.counter }

  attr_accessor :user_tag
  attr_accessible :icon, :name, :caption, :icon_cache, :remote_icon_url, :user_tag
  
  scope :where_public, lambda{
    taggings = ActsAsTaggableOn::Tagging.arel_table
    where(taggings[:tagger_type].eq("User")).includes(:tag_taggings,:image=>[:user=>[:character=>:profile]])
  }
  
  def user_tag
    @user_tag ||= (self.owner_tag_list_on(self.image.user, :tags) if self.image.respond_to?(:user))
  end
  
  clean_before_validation :name
  sanitize_before_validation :caption
end
