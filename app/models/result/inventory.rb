class Result::Inventory < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :item
  attr_accessible :number
  
  has_many :item_names,     :through => :item
  has_many :item_strengths, :through => :item
  has_many :item_elements,  :through => :item
  has_many :item_sups,      :through => :item
  
  has_one :type, :through => :item, :class_name => "GameData::ItemType"
  
  def name
    item_name.try(:name)
  end
  
  def type_name
    type.name
  end
  
  def caption
    item_name.try(:caption)
  end
  
  def element_name
    item_element.try(:element).try(:name).nil? ? "　　　" : "【#{item_element.try(:element).try(:name)}】"
  end
  
  def element_color
    item_element.try(:element).try(:color)
  end
  
  def strength
    item_strength.try(:strength).to_i
  end
  
  def sup(kind)
    if item_sup(kind).try(:sup).try(:name).present? and item_sup(kind).lv.present?
      sup = "#{item_sup(kind).sup.name}LV#{item_sup(kind).lv}"
    else
      sup = item_sup(kind).try(:sup).try(:name)
    end
    if kind.to_sym == :G
      sup.nil? ? "" : " + #{sup}"
    else
      sup || "-"
    end
  end
  
  def item_name
    day_arel = Day.arel_table
    day_i = self.day.try(:day)
    
    item_names.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).includes(:user).first
  end
  
  def item_element
    day_arel = Day.arel_table
    day_i = self.day.try(:day)
    
    item_elements.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).includes(:user).includes(:element).first
  end
  
  def item_strength
    day_arel = Day.arel_table
    day_i = self.day.try(:day)
    
    item_strengths.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).includes(:user).first
  end
  
  def item_sup(kind)
    day_arel = Day.arel_table
    day_i = self.day.try(:day)
    
    item_sups.where(:kind => kind).where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).includes(:user).includes(:sup).first
  end
end
