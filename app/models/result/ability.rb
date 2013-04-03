class Result::Ability < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :ability, :class_name => "GameData::Ability"
  attr_accessible :caption, :forget, :lv, :lv_cap, :lv_cap_exp, :lv_exp, :name

  has_one :train, :through => :ability, :class_name => "GameData::Train"

  def nickname
    name || ability.name
  end
end
