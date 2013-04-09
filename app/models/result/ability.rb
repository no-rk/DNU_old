class Result::Ability < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :ability, :class_name => "GameData::Ability"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name

  has_one :train, :through => :ability, :class_name => "GameData::Train"
  has_many :ability_definitions, :through => :ability, :class_name => "GameData::AbilityDefinition"

  def grow_using_point_name!(point_name)
    point_arel = GameData::Point.arel_table
    result_point = self.character.result(:point, self.day.day).where(point_arel[:name].eq(point_name)).includes(:point).first
    if result_point.present?
      result_point.value -= self.require_point
      if result_point.save
        self.lv += 1
        self.save!
      end
    end
  end
  
  def require_point
    lv.to_i
  end
  def nickname
    name || ability.name
  end
end
