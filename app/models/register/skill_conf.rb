class Register::SkillConf < ActiveRecord::Base
  belongs_to :skill
  belongs_to :game_data_skill, :class_name => "GameData::Skill"
  attr_accessible :kind, :game_data_skill_id
  
  has_one  :skill_name, :dependent => :destroy
  
  accepts_nested_attributes_for :skill_name
  
  attr_accessible :skill_name_attributes
  
  validates :game_data_skill, :presence => true
  validates :kind,            :inclusion => { :in => ["battle"] }
end
