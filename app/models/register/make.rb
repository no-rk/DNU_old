class Register::Make < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_one :profile, :dependent => :destroy, :as => :character
  accepts_nested_attributes_for :profile, :allow_destroy => true

  attr_accessible :profile_attributes
end
