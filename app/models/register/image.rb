class Register::Image < ActiveRecord::Base
  belongs_to :user

  has_many :upload_icons  , :order => "id ASC", :dependent => :destroy
  accepts_nested_attributes_for :upload_icons, :allow_destroy => true

  attr_accessible :profile_attributes, :upload_icons_attributes
end
