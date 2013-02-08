class Register::Battle < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_many :battle_settings, :order => "priority ASC", :dependent => :destroy
  accepts_nested_attributes_for :battle_settings, :allow_destroy => true, :reject_if => :all_blank

  attr_accessible :battle_settings_attributes

  def build_battle
    (8-self.battle_settings.size).times{self.battle_settings.build}
  end
end
