class Result::SendPoint < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :send_point, :class_name => "Register::SendPoint"
  has_one :point, :through => :send_point, :class_name => "GameData::Point"
  has_one :to, :through => :send_point, :class_name => "User", :source => :user
  attr_accessible :success
  
  scope :receive_points, lambda{ |user_id, day_i|
    day_arel = Day.arel_table
    send_point_arel = Register::SendPoint.arel_table
    where(:success => true).where(day_arel[:day].eq(day_i)).includes(:day).where(send_point_arel[:user_id].eq(user_id)).includes(:send_point).includes(:point)
  }
end
