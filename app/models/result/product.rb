class Result::Product < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :product, :class_name => "GameData::Product"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :result_points, :through => :passed_day, :class_name => "Result::Point"
  
  has_one :train, :through => :product, :class_name => "GameData::Train"
  
  validates :passed_day, :presence => true
  validates :product,    :presence => true
  
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
  def nickname
    name || product.name
  end
end
