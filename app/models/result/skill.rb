class Result::Skill < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :skill, :class_name => "GameData::Skill"
  attr_accessible :caption, :exp, :forget, :name
  
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
