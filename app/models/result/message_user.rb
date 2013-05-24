class Result::MessageUser < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :message_user, :class_name => "Register::MessageUser"
  attr_accessible :html
  
  has_one :receiver, :through => :message_user, :source => :user
  has_ancestry
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  validates :passed_day, :presence => true
  
  scope :receives, lambda{ |user_id, day_i|
    day_arel  = Day.arel_table
    user_arel = User.arel_table
    where(day_arel[:day].eq(day_i)).includes(:day).where(user_arel[:id].eq(user_id)).includes(:receiver)
  }
  
  def html
    super.html_safe
  end
end
