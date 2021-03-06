class Register::Supplement < ActiveRecord::Base
  belongs_to :productable, :polymorphic => true
  belongs_to :art_effect, :class_name => "GameData::ArtEffect"
  belongs_to :user
  attr_accessible :experiment, :item_number, :material_number, :message, :art_effect_id, :user_id
  
  has_one :art, :through => :art_effect, :class_name => "GameData::Art"
  
  validates :art_effect, :presence => true
  validates :user_id,         :numericality => { :only_integer => true, :greater_than => 0 }
  validates :material_number, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :item_number,     :numericality => { :only_integer => true, :greater_than => 0 }
  validates :experiment,      :inclusion => { :in => [true, false] }
  validates :message,         :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
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
  
  def supplement!(way = self.art, day_i = self.day.day)
    success = false
    if self.user.permit?(:product, smith.id, day_i)
      inventory = self.user.result(:inventory, day_i).where(:number => self.material_number).first if self.user.present?
      if inventory.try(:material?)
        result_item = self.user.result(:inventory, day_i).where(:number => self.item_number).first.try(:item)
        if art_effect.tree[:supplementable_equip_types].include?(result_item.try(:equip_type))
          item_data = item_data_from_material(inventory.item, result_item, day_i)
          sup = result_item.update_item_by_data(item_data, self.smith, way, day_i)
          if sup.present?
            if self.experiment
              sup.item = nil
              sup.save!
            else
              inventory.destroy
              result_item.save!
            end
            success = sup
          end
        end
      end
    end
    success
  end
  
  def item_data_from_material(material, target_item, day_i = self.day.day)
    if material.plan.present?
      material_data = material.plan.tree[:item_sups].find{ |e| e[:equip_type].to_s == target_item.equip_type.to_s }
    end
    material_data ||= {}
    
    product_sup = self.smith.result(:art, day_i).merge(GameData::Art.find_by_name(self.art.name)).first
    sup_lv = product_sup.try(:effective_lv).to_i
    
    # 鍛治LVが付加発現LVより低い場合はクリア
    material_data = {} if sup_lv < material_data[:lv].to_i
    
    item_data = {
      :B        => GameData::Sup.sup_comp(material_data[:sup], target_item.item_sup(:B).try(:to_hash)),
      :source   => material
    }
    item_data
  end
end
