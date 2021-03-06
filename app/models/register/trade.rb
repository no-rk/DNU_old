class Register::Trade < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :send_points, :order => "id ASC", :dependent => :destroy
  has_many :send_items , :order => "id ASC", :dependent => :destroy

  accepts_nested_attributes_for :send_points, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| k.to_sym==:point_id ? true : v.blank?} }
  accepts_nested_attributes_for :send_items,  :allow_destroy => true, :reject_if => :all_blank

  attr_accessible  :send_points_attributes, :send_items_attributes

  def build_trade
    (5-self.send_points.size).times{self.send_points.build}
    (5-self.send_items.size).times{self.send_items.build}
  end
end
