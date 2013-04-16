class Register::Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :forges,      :order => "id ASC", :dependent => :destroy
  has_many :supplements, :order => "id ASC", :dependent => :destroy

  accepts_nested_attributes_for :forges,      :reject_if => proc { |attributes| attributes.all? {|k,v| k.to_sym==:experiment ? true : v.blank?} }
  accepts_nested_attributes_for :supplements, :reject_if => proc { |attributes| attributes.all? {|k,v| k.to_sym==:experiment ? true : v.blank?} }

  attr_accessible  :forges_attributes, :supplements_attributes

  def build_product
    (3-self.forges.size).times{self.forges.build}
    (3-self.supplements.size).times{self.supplements.build}
  end
end
