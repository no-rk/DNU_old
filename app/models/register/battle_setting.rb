class Register::BattleSetting < ActiveRecord::Base
  belongs_to :battlable,     :polymorphic => true
  belongs_to :skill,         :class_name => "GameData::Skill"
  belongs_to :use_condition, :class_name => "GameData::BattleSetting"
  belongs_to :frequency,     :class_name => "GameData::BattleSetting"
  belongs_to :target,        :class_name => "GameData::BattleSetting"
  
  attr_accessible :skill_id, :frequency_id, :message, :priority, :target_id, :target_variable, :use_condition_id, :use_condition_variable, :condition
  serialize :condition
  
  validates :skill,         :presence => true
  validates :priority,      :numericality => { :only_integer => true, :greater_than => 0 }
  validates :use_condition, :presence => true
  validates :frequency,     :presence => true
  validates :condition,     :presence => true
  validates :message,       :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :message
  before_validation :set_condition
  
  def tree
    @tree ||= {
      :skill => {
        :name      => skill.name,
        :priority  => priority,
      }.merge(condition)
    }
  end
  
  def use_conditions
    @use_conditions ||= GameData::BattleSetting.select([:id,:name]).find_all_by_kind('使用条件').inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
  end
  
  def frequencies
    @frequencies ||= GameData::BattleSetting.select([:id,:name]).find_all_by_kind('使用頻度').inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
  end
  
  def targets
    @targets ||= GameData::BattleSetting.select([:id,:name]).find_all_by_kind('対象指定').inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
  end
  
  def selected_frequency
    @selected_frequency ||= GameData::BattleSetting.select(:id).find_by_name('頻度5').id
  end
  
  def selected_use_condition
    @selected_use_condition ||= GameData::BattleSetting.select(:id).find_by_name('通常時').id
  end
  
  private
  def set_condition
    skill_condition = DNU::Data.parse(:skill_condition, "#{self.use_condition.name} #{self.frequency.name}")
    if skill_condition.present?
      self.condition = set_condition_tree(skill_condition)
    else
      errors.add(:condition, :invalid)
    end
  end
  
  def set_condition_tree(tree)
    case tree
    when Hash
      tree.inject({}){ |h,(k,v)|
        h.tap{
          if k == :variable
            if v[:name].to_sym == :A
              h[:fixnum] = self.use_condition_variable
            else
              h[:fixnum] = self.target_variable
            end
          else
            h[k] = set_condition_tree(v)
          end
        }
      }
    when Array
      tree.map{ |v| set_condition_tree(v) }
    else
      tree
    end
  end
end
