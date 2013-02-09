class Register::BattleSetting < ActiveRecord::Base
  belongs_to :battlable, :polymorphic => true
  belongs_to :skill,     :class_name => "GameData::Skill"
  
  validates :skill_id,      :presence => true
  validates :priority,      :presence => true
  validates :use_condition, :presence => true
  validates :frequency,     :presence => true
  validates :message,       :length => { :maximum => Settings.profile.introduction.maximum, :tokenizer => DNU::Sanitize.counter }
  
  attr_accessible :skill_id, :frequency, :message, :priority, :target, :target_variable, :use_condition, :use_condition_variable
end
