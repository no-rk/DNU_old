class Register::SendPoint < ActiveRecord::Base
  belongs_to :trade
  belongs_to :point, :class_name => "GameData::Point"
  belongs_to :user
  attr_accessible :point_id, :user_id, :message, :value
end
