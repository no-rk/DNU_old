class Result::Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :way, :polymorphic => true
  belongs_to :plan, :class_name => "GameData::Item"
  belongs_to :type, :class_name => "GameData::ItemType"
  belongs_to :source, :class_name => "Result::Item"

  has_many :item_names,     :dependent => :destroy
  has_many :item_strengths, :dependent => :destroy
  has_many :item_elements,  :dependent => :destroy
  has_many :item_sups,      :dependent => :destroy

  attr_accessible :protect
  
  has_many :result_inventories, :class_name => "Result::Inventory"
  has_many :passed_days, :through => :result_inventories, :class_name => "Result::PassedDay"
  
  validates :user,    :presence => true
  validates :day,     :presence => true
  validates :type,    :presence => true
  validates :protect, :inclusion => { :in => [true, false] }
  
  validate :has_name?, :has_strength?
  
  def passed_days_lteq_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    self.passed_days.where(day_arel[:day].lteq(day_i)).order(day_arel[:day]).includes(:day)
  end
  
  def self.new_item_by_data(item_data, user, way = nil, day_i = Day.last_day_i)
    day = Day.find_by_day(day_i)
    result_item = self.new
    result_item.type = GameData::ItemType.find_by_name(item_data[:kind].to_s)
    item_data.each do |k, v|
      if v.present?
        case k.to_sym
        when :name
          result_item.item_names.build do |item_name|
            item_name.user    = user
            item_name.day     = day
            item_name.way     = way
            item_name.name    = item_data[:name].to_s
            item_name.caption = item_data[:caption].to_s if item_data[:caption].present?
            item_name.source  = item_data[:source] if item_data[:source].present?
          end
        when :element
          result_item.item_elements.build do |item_element|
            item_element.user    = user
            item_element.day     = day
            item_element.way     = way
            item_element.element = GameData::Element.find_by_name(item_data[:element].values.first.to_s)
            item_element.source  = item_data[:source] if item_data[:source].present?
          end
        when :strength
          result_item.item_strengths.build do |item_strength|
            item_strength.user     = user
            item_strength.day      = day
            item_strength.way      = way
            item_strength.strength = item_data[:strength].to_i
            item_strength.source   = item_data[:source] if item_data[:source].present?
          end
        when :A, :B, :G
          result_item.item_sups.build do |item_sup|
            item_sup.user    = user
            item_sup.day     = day
            item_sup.way     = way
            item_sup.kind    = k.to_s
            item_sup.sup     = GameData::Sup.find_by_name(v[:name].to_s)
            item_sup.lv      = v[:lv].to_i if v[:lv].present?
            item_sup.source  = item_data[:source] if item_data[:source].present?
          end
        end
      end
    end
    result_item
  end
  
  def update_item_by_data(item_data, user, way = nil, day_i = Day.last_day_i)
    success = false
    day = Day.find_by_day(day_i)
    item_data.each do |k, v|
      if v.present?
        case k.to_sym
        when :name
          self.item_names.build do |item_name|
            item_name.user    = user
            item_name.day     = day
            item_name.way     = way
            item_name.name    = item_data[:name].to_s
            item_name.caption = item_data[:caption].to_s if item_data[:caption].present?
            item_name.source  = item_data[:source] if item_data[:source].present?
            success = item_name
          end
        when :element
          self.item_elements.build do |item_element|
            item_element.user    = user
            item_element.day     = day
            item_element.way     = way
            item_element.element = GameData::Element.find_by_name(item_data[:element].values.first.to_s)
            item_element.source  = item_data[:source] if item_data[:source].present?
            success = item_element
          end
        when :strength
          self.item_strengths.build do |item_strength|
            item_strength.user     = user
            item_strength.day      = day
            item_strength.way      = way
            item_strength.strength = item_data[:strength].to_i
            item_strength.source   = item_data[:source] if item_data[:source].present?
            success = item_strength
          end
        when :A, :B, :G
          self.item_sups.build do |item_sup|
            item_sup.user    = user
            item_sup.day     = day
            item_sup.way     = way
            item_sup.kind    = k.to_s
            item_sup.sup     = GameData::Sup.find_by_name(v[:name].to_s)
            item_sup.lv      = v[:lv].to_i if v[:lv].present?
            item_sup.source  = item_data[:source] if item_data[:source].present?
            success = item_sup
          end
        end
      end
    end
    success
  end
  
  def self.new_item_by_type_and_name(item_type, item_name, user, way = nil, day_i = Day.last_day_i)
    item_plan = GameData::Item.where(:kind => item_type, :name => item_name).first
    
    if item_plan.present?
      parser    = EffectParser.new
      transform = EffectTransform.new
      
      item_data = parser.item_definition.parse(item_plan.definition)
      item_data = transform.apply(item_data)
      
      result_item = self.new_item_by_data(item_data, user, way, day_i)
      result_item.user    = user
      result_item.day     = Day.find_by_day(day_i)
      result_item.way     = way
      result_item.plan    = item_plan
      result_item.protect = item_data[:protect].present?
    end
    result_item
  end
  
  def self.new_item_from_material(material, register_forge, way = nil, day_i = register_forge.day.day)
    item_data = register_forge.item_data_from_material(material, day_i)
    
    result_item = self.new_item_by_data(item_data, register_forge.smith, way, day_i)
    result_item.user    = register_forge.smith
    result_item.day     = Day.find_by_day(day_i)
    result_item.way     = way
    result_item.source  = material
    result_item.protect = material.protect
    result_item
  end
  
  def item_name(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    item_name_arel = Result::ItemName.arel_table
    
    item_names.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc, item_name_arel[:id].desc).includes(:day).limit(1).includes(:user).first
  end
  
  def item_element(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    item_element_arel = Result::ItemElement.arel_table
    
    item_elements.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc, item_element_arel[:id].desc).includes(:day).limit(1).includes(:user).includes(:element).first
  end
  
  def item_strength(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    item_strength_arel = Result::ItemStrength.arel_table
    
    item_strengths.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc, item_strength_arel[:id].desc).includes(:day).limit(1).includes(:user).first
  end
  
  def item_sup(kind, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    item_sup_arel = Result::ItemSup.arel_table
    
    item_sups.where(:kind => kind).where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc, item_sup_arel[:id].desc).includes(:day).limit(1).includes(:user).includes(:sup).first
  end
  
  def equip_type
    self.type.item_equip.try(:kind)
  end

  private
  def has_name?
    if self.item_names.blank?
      errors.add(:item_names, :invalid)
    end
  end
  def has_strength?
    if self.item_strengths.blank?
      errors.add(:item_strengths, :invalid)
    end
  end
end
