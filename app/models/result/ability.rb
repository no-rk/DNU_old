class Result::Ability < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :ability, :class_name => "GameData::Ability"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name

  has_one :train, :through => :ability, :class_name => "GameData::Train"
  has_many :ability_definitions, :through => :ability, :class_name => "GameData::AbilityDefinition"
  
  def self.first_learn?(ability_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    !self.where(day_arel[:day].lteq(day_i.to_i-1)).includes(:day).exists?(:ability_id => ability_id)
  end

  def grow_using_point_name!(point_name)
    success = false
    point_arel = GameData::Point.arel_table
    result_point = self.character.result(:point, self.day.day).where(point_arel[:name].eq(point_name)).includes(:point).first
    if result_point.present?
      result_point.value -= self.require_point
      if result_point.save
        self.lv += 1
        self.save!
        success = true
      end
    end
    success
  end
  
  def value(n = lv)
    "LV#{n.to_i}"
  end
  def require_point(n = lv)
    n.to_i
  end
  def nickname
    name || ability.name
  end
end
