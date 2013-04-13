class Register::Forge < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  belongs_to :item_type, :class_name => "GameData::ItemType"
  attr_accessible :caption, :experiment, :message, :name, :number, :user_id, :item_type_id
  
  has_one :smith, :through => :product, :class_name => "User", :source => :user
  has_one :day,   :through => :product
  
  validates :user_id,      :numericality => { :only_integer => true, :greater_than => 0 }
  validates :number,       :numericality => { :only_integer => true, :greater_than => 0 }
  validates :item_type_id, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :experiment,   :inclusion => { :in => [true, false] }
  validates :name,         :presence => true, :length => { :maximum => 20 }
  validates :caption,      :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
  validates :message,      :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
  
  def forge!(way = GameData::Product.find_by_name("鍛治"), day_i = self.day.day)
    success = false
    inventory = self.user.result(:inventory, day_i).where(:number => self.number).first if self.user.present?
    if inventory.try(:type).try(:name).to_s == "材料"
      result_item = Result::Item.new_item_from_material(inventory.item, self, way, day_i)
      if result_item.try(:save)
        unless self.experiment
          inventory.item = result_item
          inventory.save!
        end
        success = result_item
      end
    end
    success
  end
  
  def item_data_from_material(material, day_i = self.day.day)
    parser    = EffectParser.new
    transform = EffectTransform.new
    
    if material.plan.try(:definition).present?
      material_data = parser.item_definition.parse(material.plan.definition)
      material_data = transform.apply(material_data)
      material_data = material_data[:item_sups].find{ |e| e[:equip_type].to_s == self.item_type.item_equip.try(:kind).to_s }
    end
    material_data ||= {}
    
    product_arel  = GameData::Product.arel_table
    product_forge = self.smith.result(:product).where(product_arel[:name].eq("鍛治")).includes(:product).first
    forge_lv = (product_forge.try(:lv_cap).nil? ? product_forge.try(:lv) : [product_forge.lv, product_forge.lv_cap].min).to_i
    
    # 鍛治LVが付加発現LVより低い場合はクリア
    material_data = {} if forge_lv < material_data[:lv].to_i
    
    item_data = {
      :kind     => self.item_type.name,
      :name     => self.name,
      :caption  => self.caption,
      :element  => material_data[:element],
      :strength => material.item_strength(day_i).strength.to_i + forge_lv*10,
      :A        => material_data[:sup],
      :G        => material_data[:G],
      :source   => material
    }
    item_data
  end
end
