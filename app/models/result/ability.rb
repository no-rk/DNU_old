class Result::Ability < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :ability, :class_name => "GameData::Ability"
  belongs_to :ability_conf, :class_name => "Register::AbilityConf"
  attr_accessible :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :result_points, :through => :passed_day, :class_name => "Result::Point"
  
  has_one :train,                :through => :ability, :class_name => "GameData::Train"
  has_many :ability_definitions, :through => :ability, :class_name => "GameData::AbilityDefinition"
  
  has_one :ability_name, :through => :ability_conf, :class_name => "Register::AbilityName"
  
  validates :passed_day, :presence => true
  validates :ability,    :presence => true
  
  def self.first_learn?(ability_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    !self.where(day_arel[:day].lteq(day_i.to_i-1)).includes(:day).exists?(:ability_id => ability_id)
  end

  def grow_using_point_name!(point_name)
    success = false
    point_arel = GameData::Point.arel_table
    result_point = self.result_points.where(point_arel[:name].eq(point_name)).includes(:point).first
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
  def forget_point(n = lv)
    n.to_i*2
  end
  def nickname
    ability_name.try(:name).blank? ? ability.name : ability_name.name
  end
end
