class Register::Main < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :moves, :order => "id ASC", :dependent => :destroy
  accepts_nested_attributes_for :moves, :allow_destroy => true
  has_many :trains, :order => "id ASC", :dependent => :destroy
  accepts_nested_attributes_for :trains, :allow_destroy => true, :reject_if => :all_blank
  attr_accessible :moves_attributes, :trains_attributes

  def build_main
    (5-self.moves.size).times{self.moves.build}
    (8-self.trains.size).times{self.trains.build}
  end
end
