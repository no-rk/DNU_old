class Result::ItemSup < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :sup, :class_name => "GameData::Sup"
  belongs_to :source, :class_name => "Result::Item"
  attr_accessible :kind, :lv
  
  validates :user, :presence => true
  validates :day,  :presence => true
  validates :kind, :inclusion => { :in => ["A", "B", "G"] }
  validates :sup,  :presence => true
  validates :lv,   :allow_nil => true, :numericality => { :only_integer => true, :greater_than => 0 }
end
