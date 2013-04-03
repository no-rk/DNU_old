class Result::Product < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :product, :class_name => "GameData::Product"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name

  has_one :train, :through => :product, :class_name => "GameData::Train"

  def nickname
    name || product.name
  end
end
