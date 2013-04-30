class Register::Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :event_content, :class_name => "GameData::EventContent"
  attr_accessible :purchases_attributes, :event_content_id
  
  has_one :event_step, :through => :event_content, :class_name => "GameData::EventStep"
  has_one :event,      :through => :event_step,    :class_name => "GameData::Event"
  
  has_many :purchases, :order => "id ASC", :dependent => :destroy
  
  accepts_nested_attributes_for :purchases, :reject_if => :all_blank
  
  
  validates :user,             :presence => true
  validates :event_content,    :presence => true
  
  before_validation :set_event_form
  
  def build_event
    case event_content.kind.to_sym
    when :purchase
      (8-self.purchases.size).times{self.purchases.build}
    end
  end
  
  private
  def set_event_form
    case event_content.kind.to_sym
    when :purchase
      set_item_and_point
    end
  end
  
  def set_item_and_point
    self.purchases.each do |purchase|
      purchase.item  = GameData::Item.find_by_kind_and_name(event_content.content[purchase.index.to_i][:kind], event_content.content[purchase.index.to_i][:name])
      purchase.price = event_content.content[purchase.index.to_i][:price].to_i
      purchase.point = GameData::Point.find_by_name(event_content.content[purchase.index.to_i][:point])
    end
  end
end
