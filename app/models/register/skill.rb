class Register::Skill < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  
  has_many :skill_confs, :order => "game_data_skill_id ASC", :dependent => :destroy
  accepts_nested_attributes_for :skill_confs
  attr_accessible :skill_confs_attributes
  
  has_many :skill_names, :through => :skill_confs
  
  def build_skill
  end
end
