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
  
  def self.new_item_by_data(item_data, user = nil, way = nil, day_i = Day.last_day_i)
    day = Day.find_by_day(day_i)
    result_item = self.new
    result_item.type = GameData::ItemType.find_by_name(item_data[:kind].to_s)
    item_data.each do |k, v|
      case k.to_sym
      when :name
        result_item.item_names.build
        result_item.item_names.last.user = user
        result_item.item_names.last.day = day
        result_item.item_names.last.way = way
        result_item.item_names.last.name = item_data[:name].to_s
        result_item.item_names.last.caption = item_data[:caption].to_s if item_data[:caption].present?
      when :element
        result_item.item_elements.build
        result_item.item_elements.last.user = user
        result_item.item_elements.last.day = day
        result_item.item_elements.last.way = way
        result_item.item_elements.last.element = GameData::Element.find_by_name(item_data[:element].values.first.to_s)
      when :strength
        result_item.item_strengths.build
        result_item.item_strengths.last.user = user
        result_item.item_strengths.last.day = day
        result_item.item_strengths.last.way = way
        result_item.item_strengths.last.strength = item_data[:strength].to_i
      when :A, :B, :G
        result_item.item_sups.build
        result_item.item_sups.last.user = user
        result_item.item_sups.last.day = day
        result_item.item_sups.last.way = way
        result_item.item_sups.last.kind = k.to_s
        result_item.item_sups.last.sup = GameData::Sup.find_by_name(v[:name].to_s)
        result_item.item_sups.last.lv = v[:lv].to_i if v[:lv].present?
      end
    end
    result_item
  end
  
  def self.new_item_by_type_and_name(item_type, item_name, user = nil, way = nil, day_i = Day.last_day_i)
    item_plan = GameData::Item.where(:kind => item_type, :name => item_name).first
    
    if item_plan.present?
      parser    = EffectParser.new
      transform = EffectTransform.new
      
      item_data = parser.item_definition.parse(item_plan.definition)
      item_data = transform.apply(item_data)
      
      result_item = self.new_item_by_data(item_data, user, way, day_i)
      result_item.user = user
      result_item.day = Day.find_by_day(day_i)
      result_item.way = way
      result_item.plan = item_plan
      result_item.protect = item_data[:protect].present?
    end
    result_item
  end
end
