class Result::Inventory < ActiveRecord::Base
  belongs_to :passed_day
  belongs_to :item
  attr_accessible :number
  
  has_one :user, :through => :passed_day
  has_one :day,  :through => :passed_day
  
  has_many :item_names,     :through => :item
  has_many :item_strengths, :through => :item
  has_many :item_elements,  :through => :item
  has_many :item_sups,      :through => :item
  
  has_one :type, :through => :item, :class_name => "GameData::ItemType"
  
  has_one :result_equip, :class_name => "Result::Equip"
  
  validates :passed_day, :presence => true
  validates :item,       :presence => true
  validates :number,     :numericality => { :only_integer => true, :greater_than => 0 }
  
  def send_to_user!(to_user)
    success = false
    unless self.item.protect
      if to_user.present?
        result_inventory = to_user.new_inventory(self.day.day)
        if result_inventory.number.present?
          result_inventory.item = self.item
          if result_inventory.save
            self.destroy
            success = true
          end
        end
      end
    end
    success
  end
  
  def equip?
    if self.result_equip.try(:success)
      item.equip_type
    end
  end
  
  def material?
    self.type_name.to_s == "材料"
  end
  
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
    item.item_name(self.day.day)
  end
  
  def item_element
    item.item_element(self.day.day)
  end
  
  def item_strength
    item.item_strength(self.day.day)
  end
  
  def item_sup(kind)
    item.item_sup(kind, self.day.day)
  end
end
