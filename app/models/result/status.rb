class Result::Status < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :status, :class_name => "GameData::Status"
  attr_accessible :bonus, :caption, :count, :name

  has_one :train, :through => :status, :class_name => "GameData::Train"

  def value
    50 + count.to_i*5
  end
  def nickname
    name || status.name
  end
end
