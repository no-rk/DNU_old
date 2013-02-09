class Register::Battle < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_many :battle_settings, :order => "priority ASC", :dependent => :destroy, :as => :battlable
  accepts_nested_attributes_for :battle_settings, :allow_destroy => true, :reject_if => :no_change_from_default

  attr_accessible :battle_settings_attributes

  def build_battle
    (8-self.battle_settings.size).times{self.battle_settings.build}
  end
  
  private
  def no_change_from_default(row)
    # priorityとuse_conditionとfrequency以外が全てブランクの場合リジェクト
    row.all?{ |k,v| [:priority, :use_condition, :frequency].any?{ |x| k.to_sym==x } ? true : v.blank? }
  end
  
end
