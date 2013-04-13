class Result::SendItem < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :send_item, :class_name => "Register::SendItem"
  belongs_to :item, :class_name => "Result::Item"
  attr_accessible :number, :success
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  has_one :to,   :through => :send_item, :class_name => "User", :source => :user
  
  validates :passed_day, :presence => true
  validates :send_item,  :presence => true
  validates :number,     :allow_nil => true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :success,    :inclusion => { :in => [true, false] }
  
  scope :receives, lambda{ |user_id, day_i|
    day_arel = Day.arel_table
    send_item_arel = Register::SendItem.arel_table
    where(:success => true).where(day_arel[:day].eq(day_i)).includes(:day).where(send_item_arel[:user_id].eq(user_id)).includes(:send_item).includes(:item)
  }
end
