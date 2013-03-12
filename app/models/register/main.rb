class Register::Main < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :moves, :order => "id ASC", :dependent => :destroy
  accepts_nested_attributes_for :moves, :allow_destroy => true

  attr_accessible :moves_attributes

  def build_main
    (5-self.moves.size).times{self.moves.build}
  end
end
