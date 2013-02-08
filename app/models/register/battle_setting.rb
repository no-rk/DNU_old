class Register::BattleSetting < ActiveRecord::Base
  belongs_to :battle
  belongs_to :usable, :polymorphic => true
  
  validates :usable_id,     :presence => true
  validates :usable_type,   :presence => true
  validates :priority,      :presence => true
  validates :use_condition, :presence => true
  validates :frequency,     :presence => true
  validates :message,       :length => { :maximum => Settings.profile.introduction.maximum, :tokenizer => DNU::Sanitize.counter }
  
  attr_accessible :usable_id, :usable_type, :frequency, :message, :priority, :target, :target_variable, :use_condition, :use_condition_variable
end
