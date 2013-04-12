class Result::PassedDay < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  attr_accessible :passed_day
  
  has_many :result_battle_values, :dependent => :destroy, :class_name => "Result::BattleValue"
end
