class Result::Art < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :art, :class_name => "GameData::Art"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name

  has_one :train, :through => :art, :class_name => "GameData::Train"

  def nickname
    name || art.name
  end
end
