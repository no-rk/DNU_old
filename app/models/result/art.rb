class Result::Art < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :art,      :class_name => "GameData::Art"
  belongs_to :art_conf, :class_name => "Register::Art"
  attr_accessible :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one  :art_name,      :through => :art_conf,   :class_name => "Register::ArtName"
  has_many :result_points, :through => :passed_day, :class_name => "Result::Point"
  
  has_one :art_type,   :through => :art, :class_name => "GameData::ArtType"
  has_one :art_effect, :through => :art, :class_name => "GameData::ArtEffect"
  has_one :train,      :through => :art, :class_name => "GameData::Train"
  
  validates :passed_day, :presence => true
  validates :art,        :presence => true
  
  def self.first_learn?(art_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    not self.where(day_arel[:day].lteq(day_i.to_i-1)).includes(:day).where(:art_id => art_id).exists?
  end
  
  def tree
    if self.art_effect.present?
      @tree ||= {
        :art_effect => {
          :kind => art.type,
          :name => art.name,
          :lv => lv
        }.merge(lv_effects).merge(pull_down)
      }
    end
  end
  
  def lv_effects
    @lv_effects ||= { :lv_effects => self.art_conf.try(:off_lvs) }
  end
  
  def pull_down
    @pull_down ||= { :pull_down => self.art_conf.try(:pull_down) }
  end
  
  def train_point
    art.train_point
  end
  
  def require_point(n = lv)
    art.require_point(n)
  end
  
  def blossom_point(n = lv)
    art.blossom_point(n)
  end
  
  def forget_point(n = lv)
    art.forget_point(n)
  end
  
  def grow_using_point_name!(point_name = self.train_point.name)
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
  
  def name
    art_name.try(:name) || art.name
  end
end
