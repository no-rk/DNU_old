class Register::Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :forges, :order => "id ASC", :dependent => :destroy

  accepts_nested_attributes_for :forges, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| k.to_sym==:experiment ? true : v.blank?} }

  attr_accessible  :forges_attributes

  def build_product
    (3-self.forges.size).times{self.forges.build}
  end
end
