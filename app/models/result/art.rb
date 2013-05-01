class Result::Art < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :art, :class_name => "GameData::Art"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :result_points, :through => :passed_day, :class_name => "Result::Point"
  
  has_one :art_type, :through => :art, :class_name => "GameData::ArtType"
  has_one :train,    :through => :art, :class_name => "GameData::Train"
  
  validates :passed_day, :presence => true
  validates :art,        :presence => true
  
  def self.train_point
    @@train_point ||= GameData::Point.find_by_train(self.name.split("::").last)
  end
  
  def grow_using_point_name!(point_name = self.class.train_point.name)
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
  
  def effective_lv
    (self.lv_cap.nil? ? self.lv : [self.lv, self.lv_cap].min).to_i
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
    name || art.name
  end
end
