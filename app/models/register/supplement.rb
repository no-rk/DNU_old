class Register::Supplement < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  attr_accessible :experiment, :item_number, :material_number, :message, :user_id
  
  has_one :smith, :through => :product, :class_name => "User", :source => :user
  has_one :day,   :through => :product
  
  validates :user_id,         :numericality => { :only_integer => true, :greater_than => 0 }
  validates :material_number, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :item_number,     :numericality => { :only_integer => true, :greater_than => 0 }
  validates :experiment,      :inclusion => { :in => [true, false] }
  validates :message,         :length => { :maximum => 800, :tokenizer => DNU::Sanitize.counter }
  
  def supplement!(way = GameData::Art.find_by_name("付加").first, day_i = self.day.day)
    success = false
    inventory = self.user.result(:inventory, day_i).where(:number => self.material_number).first if self.user.present?
    if inventory.try(:material?)
      result_item = self.user.result(:inventory, day_i).where(:number => self.item_number).first.try(:item)
      if result_item.present?
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
    success
  end
  
  def item_data_from_material(material, target_item, day_i = self.day.day)
    if material.plan.present?
      material_data = material.plan.tree[:item_sups].find{ |e| e[:equip_type].to_s == target_item.equip_type.to_s }
    end
    material_data ||= {}
    
    product_sup = self.smith.result(:art, day_i).merge(GameData::Art.find_by_name("付加")).first
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
