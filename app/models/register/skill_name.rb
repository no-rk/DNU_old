class Register::SkillName < ActiveRecord::Base
  belongs_to :skill_conf
  attr_accessible :caption, :name
  
  validates :name,    :length => { :maximum => 20 }
  validates :caption, :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
end
