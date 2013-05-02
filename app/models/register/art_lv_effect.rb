class Register::ArtLvEffect < ActiveRecord::Base
  belongs_to :art
  attr_accessible :lv, :setting
  
  validates :lv,      :numericality => { :only_integer => true, :greater_than => 0 }
  validates :setting, :inclusion => { :in => [true, false] }
end
