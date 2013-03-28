class Register::Main < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :moves,  :order => "id ASC", :dependent => :destroy
  has_many :trains, :order => "id ASC", :dependent => :destroy
  has_one  :party_slogan, :dependent => :destroy
  
  accepts_nested_attributes_for :moves,        :allow_destroy => true
  accepts_nested_attributes_for :trains,       :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :party_slogan, :allow_destroy => true, :reject_if => :all_blank
  
  attr_accessible :moves_attributes, :trains_attributes, :party_slogan_attributes

  def build_main
    (5-self.moves.size).times{self.moves.build}
    (8-self.trains.size).times{self.trains.build}
    self.build_party_slogan if self.party_slogan.nil?
  end
end
