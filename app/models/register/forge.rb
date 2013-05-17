class Register::Forge < ActiveRecord::Base
  belongs_to :productable, :polymorphic => true
  belongs_to :art_effect, :class_name => "GameData::ArtEffect"
  belongs_to :user
  belongs_to :item_type, :class_name => "GameData::ItemType"
  attr_accessible :caption, :experiment, :message, :name, :number, :art_effect_id, :user_id, :item_type_index
  
  has_one :art, :through => :art_effect, :class_name => "GameData::Art"
  
  validates :art_effect, :presence => true
  validates :user_id,    :numericality => { :only_integer => true, :greater_than => 0 }
  validates :number,     :numericality => { :only_integer => true, :greater_than => 0 }
  validates :item_type,  :presence => true
  validates :experiment, :inclusion => { :in => [true, false] }
  validates :name,       :presence => true, :length => { :maximum => Settings.maximum.name, :tokenizer => DNU::Text.counter(:string) }
  validates :caption,    :length => { :maximum => Settings.maximum.caption, :tokenizer => DNU::Text.counter(:document) }
  validates :message,    :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_string_html   :name
  dnu_document_html :caption
  dnu_message_html  :message
  
  def smith
    self.productable.try:user
  end
  
  def day
    self.productable.try:day
  end
  
  def character_active
    smith
  end
  
  def character_passive
    user
  end
  
  def item_type_index=(i)
    self.item_type = GameData::ItemType.find_by_name(self.art_effect.forgeable_item_types.invert[i.to_i])
    @item_type_index = i
  end
  
  def item_type_index
    @item_type_index || self.art_effect.forgeable_item_types[self.item_type.try(:name)]
  end
  
  def forge!(way = self.art, day_i = self.day.day)
    success = false
    inventory = self.user.result(:inventory, day_i).where(:number => self.number).first if self.user.present?
    if inventory.try(:material?)
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
    if material.plan.present?
      material_data = material.plan.tree[:item_sups].find{ |e| e[:equip_type].to_s == self.item_type.equip.try(:kind).to_s }
    end
    material_data ||= {}
    
    product_forge = self.smith.result(:art, day_i).merge(GameData::Art.find_by_name(self.art.name)).first
    forge_lv = product_forge.try(:effective_lv).to_i
    
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
