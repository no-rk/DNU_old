class Result::Place < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :map_tip, :class_name => "GameData::MapTip"
  attr_accessible :arrival
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one :map,    :through => :map_tip, :class_name => "GameData::Map"
  has_many :mains, :through => :user,    :class_name => "Register::Main"
  
  validates :passed_day, :presence => true
  validates :map_tip,    :presence => true
  validates :arrival,    :inclusion => { :in => [true, false] }
  
  def find_party_slogan_by_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    mains.where(day_arel[:day].eq(day_i)).includes(:day).includes(:party_slogan).first.try(:party_slogan).try(:slogan)
  end
  
  def name
    map_tip.name
  end
end
