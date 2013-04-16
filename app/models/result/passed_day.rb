class Result::PassedDay < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  attr_accessible :passed_day
  
  has_many :result_send_points,   :dependent => :destroy, :class_name => "Result::SendPoint"
  has_many :result_send_items,    :dependent => :destroy, :class_name => "Result::SendItem"
  has_many :result_forges,        :dependent => :destroy, :class_name => "Result::Forge"
  has_many :result_supplements,   :dependent => :destroy, :class_name => "Result::Supplement"
  has_many :result_equips ,       :dependent => :destroy, :class_name => "Result::Equip"
  has_many :result_trains,        :dependent => :destroy, :class_name => "Result::Train"
  has_many :result_learns,        :dependent => :destroy, :class_name => "Result::Learn"
  has_many :result_forgets,       :dependent => :destroy, :class_name => "Result::Forget"
  has_many :result_blossoms,      :dependent => :destroy, :class_name => "Result::Blossom"
  has_many :result_moves,         :dependent => :destroy, :class_name => "Result::Move"
  
  has_many :result_battle_values, :dependent => :destroy, :class_name => "Result::BattleValue"
  has_many :result_points,        :dependent => :destroy, :class_name => "Result::Point"
  has_many :result_jobs,          :dependent => :destroy, :class_name => "Result::Job"
  has_many :result_statuses,      :dependent => :destroy, :class_name => "Result::Status"
  has_many :result_arts,          :dependent => :destroy, :class_name => "Result::Art"
  has_many :result_products,      :dependent => :destroy, :class_name => "Result::Product"
  has_many :result_abilities,     :dependent => :destroy, :class_name => "Result::Ability"
  has_many :result_skills,        :dependent => :destroy, :class_name => "Result::Skill"
  has_many :result_inventories,   :dependent => :destroy, :class_name => "Result::Inventory"
  has_many :result_places,        :dependent => :destroy, :class_name => "Result::Place"
  
  validates :user,       :presence => true
  validates :day,        :presence => true
  validates :passed_day, :presence => true
end
