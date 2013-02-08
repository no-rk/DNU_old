class Register::Image < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_many :upload_icons  , :order => "updated_at DESC", :dependent => :destroy
  accepts_nested_attributes_for :upload_icons, :allow_destroy => true, :reject_if => :all_blank

  attr_accessible :upload_icons_attributes

  def build_image
    (5-self.upload_icons.size).times{self.upload_icons.build}
  end
end
