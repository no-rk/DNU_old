class Result::Point < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :point, :class_name => "GameData::Point"
  attr_accessible :value
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :result_arts, :through => :passed_day, :class_name => "Result::Art"
  
  validate :point_non_negative?
  
  def send_to_user!(to_user, send_value)
    success = false
    unless self.point.protect
      if to_user.present?
        self.value -= send_value.to_i
        if self.save
          result_point = to_user.result(:point, self.day.day).where(:point_id => self.point_id).first
          result_point.value += send_value.to_i
          result_point.save!
          success = true
        end
      end
    end
    success
  end
  
  def nickname
    point.name
  end
  
  private
  def point_non_negative?
    if self.point.non_negative and self.value.to_i < 0
      errors.add(:point, :non_negative)
    end
  end
end
