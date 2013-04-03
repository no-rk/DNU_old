class Result::Job < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :job, :class_name => "GameData::Job"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name

  has_one :train, :through => :job, :class_name => "GameData::Train"

  def nickname
    name || job.name
  end
end
