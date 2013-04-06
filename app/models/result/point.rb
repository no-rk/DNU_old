class Result::Point < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :point, :class_name => "GameData::Point"
  attr_accessible :value
  
  validate :point_non_negative?
  
  def nickname
    point.name
  end
  
  private
  def point_non_negative?
    p :validate
    if self.point.non_negative and self.value.to_i < 0
      errors.add(:point, :non_negative)
    end
  end
end
