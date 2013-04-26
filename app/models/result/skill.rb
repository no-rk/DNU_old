class Result::Skill < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :skill, :class_name => "GameData::Skill"
  belongs_to :skill_conf, :class_name => "Register::SkillConf"
  attr_accessible :exp, :forget
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one :skill_name, :through => :skill_conf, :class_name => "Register::SkillName"
  
  validates :passed_day, :presence => true
  validates :skill,      :presence => true
  
  def self.first_learn?(skill_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    !self.where(day_arel[:day].lteq(day_i.to_i-1)).includes(:day).exists?(:skill_id => skill_id)
  end
  
  def nickname
    skill_name.try(:name).blank? ? skill.name : skill_name.name
  end
  
  def cost
    skill.tree[:cost]
  end
end
