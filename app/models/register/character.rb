class Register::Character < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_one  :profile, :dependent => :destroy
  has_many :icons  , :order => "number ASC", :dependent => :destroy
  accepts_nested_attributes_for :profile, :allow_destroy => true
  accepts_nested_attributes_for :icons, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| k.to_sym==:number ? true : v.blank?} }

  attr_accessible :profile_attributes, :icons_attributes

  def build_character
    self.build_profile if self.profile.nil?

    numbers = (1..5).to_a - self.icons.pluck(:number)
    numbers.each{|number| self.icons.build(:number => number)}
    self.icons.sort!{|a,b| a.number<=>b.number }
  end
end
