class Result::Job < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :job, :class_name => "GameData::Job"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_one :train, :through => :job, :class_name => "GameData::Train"
  
  validates :passed_day, :presence => true
  validates :job,        :presence => true
  
  def self.train_point
    @@train_point ||= GameData::Point.find_by_train(self.name.split("::").last)
  end
  
  def nickname
    name || job.name
  end
end
