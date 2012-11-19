class Register::Character < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_one  :profile, :dependent => :destroy
  has_many :icons  , :order => "number ASC", :dependent => :destroy
  accepts_nested_attributes_for :profile, :allow_destroy => true
  accepts_nested_attributes_for :icons, :allow_destroy => true

  attr_accessible :profile_attributes, :icons_attributes
end
