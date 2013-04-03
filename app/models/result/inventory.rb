class Result::Inventory < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :item
  attr_accessible :number
  
  def item_name
    day_arel = Day.arel_table
    day_i = self.day.day
    
    item.item_names.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).first
  end
  
  def item_element
    day_arel = Day.arel_table
    day_i = self.day.day
    
    item.item_elements.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).first
  end
  
  def item_strength
    day_arel = Day.arel_table
    day_i = self.day.day
    
    item.item_strengths.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).first
  end
  
  def item_sup(kind)
    day_arel = Day.arel_table
    day_i = self.day.day
    
    item.item_sups.where(:kind => kind).where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc).includes(:day).limit(1).first
  end
end
