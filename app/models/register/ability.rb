class Register::Ability < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  
  has_many :ability_settings, :dependent => :destroy
  accepts_nested_attributes_for :ability_settings, :allow_destroy => true
  attr_accessible :ability_settings_attributes
  
  def build_ability
  end
end
