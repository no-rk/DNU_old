class Result::Skill < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :skill, :class_name => "GameData::Skill"
  attr_accessible :caption, :exp, :forget, :name
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day, :presence => true
  validates :skill,      :presence => true
  
  def self.first_learn?(skill_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    !self.where(day_arel[:day].lteq(day_i.to_i-1)).includes(:day).exists?(:skill_id => skill_id)
  end
  
  def nickname
    name || skill.name
  end
  
  def cost
    parser    = EffectParser.new
    transform = EffectTransform.new
    tree = parser.skill_definition.parse(skill.definition)
    tree = transform.apply(tree)
    tree[:cost]
  end
end
