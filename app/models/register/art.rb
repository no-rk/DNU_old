class Register::Art < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :art, :class_name => "GameData::Art"
  attr_accessible :art_id, :art_name_attributes, :art_pull_down_attributes, :art_lv_effects_attributes, :forges_attributes, :supplements_attributes, :hunts_attributes
  
  has_one :art_type,   :through => :art, :class_name => "GameData::ArtType"
  has_one :art_effect, :through => :art, :class_name => "GameData::ArtEffect"
  
  has_one  :art_name,       :dependent => :destroy
  has_one  :art_pull_down,  :dependent => :destroy
  has_many :art_lv_effects, :dependent => :destroy
  has_many :forges,         :order => "id ASC", :dependent => :destroy, :as => :productable
  has_many :supplements,    :order => "id ASC", :dependent => :destroy, :as => :productable
  has_many :hunts,          :order => "id ASC", :dependent => :destroy, :as => :productable
  
  accepts_nested_attributes_for :art_name, :reject_if => :all_blank
  accepts_nested_attributes_for :art_pull_down
  accepts_nested_attributes_for :art_lv_effects
  accepts_nested_attributes_for :forges,      :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id, :item_type_index, :experiment].include?(k.to_sym) ? true : v.blank?} }
  accepts_nested_attributes_for :supplements, :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id, :experiment].include?(k.to_sym) ? true : v.blank?} }
  accepts_nested_attributes_for :hunts,       :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id].include?(k.to_sym) ? true : v.blank?} }
  
  def build_art
    self.build_art_name if self.art_name.nil? and self.art_type.try(:rename)
    if has_pull_down?
      self.build_art_pull_down if self.art_pull_down.nil?
    end
    lvs.each do |lv|
      unless self.art_lv_effects.where(:lv => lv).exists?
        self.art_lv_effects.build(:lv => lv)
      end
    end
    [:forge, :supplement, :hunt].each do |type|
      product_count(type).times do
        self.send(type.to_s.pluralize).build(:art_effect_id => self.art_effect.id)
      end
    end
  end
  
  def product_count(type)
    if self.art_effect.present?
      self.art_effect.tree[:"#{type}able_number"].to_i-self.send(type.to_s.pluralize).where(:art_effect_id => self.art_effect.id).count
    else
      0
    end
  end
  
  def hunt_list(kinds)
    user.hunt_list(kinds, day.nil? ? Day.last_day_i : day.day-1)
  end
  
  def pull_down
    self.art_pull_down.try(:pull_down)
  end
  
  def off_lvs
    self.art_lv_effects.where(:setting => false).pluck(:lv)
  end
  
  def definitions
    if self.art_effect.present?
      @definitions ||= self.art_effect.tree[:definitions]
    else
      @definitions ||=[]
    end
  end
  
  def has_pull_down?
    pull_downs.present?
  end
  
  def pull_downs
    @pull_downs ||= definitions.find_all{|h| h[:pull_down].present? and h[:lv].to_i <= art_lv}.inject({}){ |h,v| h.tap{ h["LV#{v[:lv]}：#{v[:pull_down]}"] = v[:pull_down] } }
  end
  
  def lv_effects
    @lv_effects ||= definitions.find_all{|h| h[:pull_down].nil?     and h[:lv].to_i <= art_lv}.inject({}){ |h,v| h.tap{ h[v[:lv].to_i] = v[:caption] } }
  end
  
  def lvs
    @lvs ||= lv_effects.keys
  end
  
  def name
    art.name
  end
  
  def caption
    art.caption
  end
  
  def art_lv
    @art_lv ||= user.result(:art).where(:art_id => self.art_id).first.lv.to_i
  end
end
