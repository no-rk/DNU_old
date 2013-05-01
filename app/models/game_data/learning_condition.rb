class GameData::LearningCondition < ActiveRecord::Base
  belongs_to :learnable, :polymorphic => true
  attr_accessible :condition_group, :group_count, :lv, :name
  
  scope :find_by_state, lambda{ |state|
    conditions = nil
    state.each do |name, lv|
      condition = arel_table[:name].eq(name).and(arel_table[:lv].lteq(lv))
      if conditions.nil?
        conditions = condition
      else
        conditions = conditions.or(condition)
      end
    end
    
    select(
      [
        arel_table[:learnable_id],
        arel_table[:learnable_type],
        arel_table[:group_count]
      ]
    ).
    where(conditions).
    group(
      arel_table[:learnable_id],
      arel_table[:learnable_type],
      arel_table[:condition_group]
    ).
    having(
      arel_table[:group_count].
      eq(arel_table[:group_count].count)
    ).
    includes(:learnable)
  }
  
  def self.find_learnable(state, type = nil)
    case type.try(:to_sym)
    when :skill
      find_by_state(state).where(:learnable_type => "GameData::Skill").map{ |r| r.learnable }
    when :art
      find_by_state(state).where(:learnable_type => "GameData::ArtEffect").map{ |r| r.learnable.art }
    else
      find_by_state(state).map{ |r| r.learnable }
    end
  end
end
