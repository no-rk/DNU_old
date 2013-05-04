class Register::Pet < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :pet, :class_name => "Result::Pet"
  attr_accessible :pet_id, :profile_attributes, :battle_settings_attributes
  
  has_one :plan, :through => :pet, :class_name => "GameData::Character"
  
  has_one  :profile,         :dependent => :destroy, :as => :character
  has_many :battle_settings, :order => "priority ASC", :dependent => :destroy, :as => :battlable
  
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :battle_settings, :reject_if => :no_change_from_default
  
  def learned_skills
    @learned_skills ||= pet.pet_skills.inject({}){|h,r| h.tap{ h["#{r.skill.name} 消費#{r.skill.tree[:cost]}"] = r.skill.id } }
  end
  
  def build_pet
    if self.profile.nil?
      self.build_profile
      self.profile.name     = self.plan.name
      self.profile.nickname = self.plan.name
    end
    (2-self.battle_settings.size).times{self.battle_settings.build}
  end
  
  private
  def no_change_from_default(row)
    # priorityとuse_conditionとfrequency以外が全てブランクの場合リジェクト
    row.all?{ |k,v| [:priority, :use_condition_id, :frequency_id].include?(k.to_sym) ? true : v.blank? }
  end
end
