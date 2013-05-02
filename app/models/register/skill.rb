class Register::Skill < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :skill, :class_name => "GameData::Skill"
  attr_accessible :skill_id, :skill_name_attributes
  
  has_one :skill_name, :dependent => :destroy
  
  accepts_nested_attributes_for :skill_name, :reject_if => :all_blank
  
  def build_skill
    self.build_skill_name if self.skill_name.nil?
  end
end
