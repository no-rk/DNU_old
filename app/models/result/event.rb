class Result::Event < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :event, :class_name => "GameData::Event"
  attr_accessible :state
  
  has_many :event_states,    :dependent => :destroy
  has_many :event_variables, :dependent => :destroy
  
  accepts_nested_attributes_for :event_states
  accepts_nested_attributes_for :event_variables
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :event_steps,    :through => :event_states, :class_name => "GameData::EventStep"
  has_many :event_contents, :through => :event_steps,  :class_name => "GameData::EventContent"
  
  validates :passed_day, :presence => true
  validates :event,      :presence => true
  validates :state,      :inclusion => { :in => ["途中", "終了"] }
end
