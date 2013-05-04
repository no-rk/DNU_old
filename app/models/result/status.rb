class Result::Status < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :status, :class_name => "GameData::Status"
  attr_accessible :bonus, :caption, :count, :name
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :result_points, :through => :passed_day, :class_name => "Result::Point"
  
  has_one :train, :through => :status, :class_name => "GameData::Train"
  
  validates :passed_day, :presence => true
  validates :status,     :presence => true
  validates :count,      :numericality => { :only_integer => true, :greater_than_or_euql_to => 0 }
  validates :bonus,      :numericality => { :only_integer => true, :greater_than_or_euql_to => 0 }
  
  def train_point
    self.status.train_point
  end
  
  def tree
    @tree ||= { :status => { :name => status.name, :status_strength => value + bonus } }
  end
  
  def grow_using_point_name!(point_name = self.train_point.name)
    success = false
    point_arel = GameData::Point.arel_table
    result_point = self.result_points.where(point_arel[:name].eq(point_name)).includes(:point).first
    if result_point.present?
      result_point.value -= self.require_point
      if result_point.save
        self.count += 1
        self.save!
        success = true
      end
    end
    success
  end
  
  def value(n = count)
    ((1.0/4)*(n+10)*(n+20)).ceil
  end
  def require_point(n = count)
    (value(n)/10).to_i
  end
  def nickname
    name || status.name
  end
end
