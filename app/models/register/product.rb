class Register::Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  
  has_many :forges,      :order => "id ASC", :dependent => :destroy, :as => :productable
  has_many :supplements, :order => "id ASC", :dependent => :destroy, :as => :productable
  has_many :hunts,       :order => "id ASC", :dependent => :destroy, :as => :productable
  
  accepts_nested_attributes_for :forges,      :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id, :item_type_index, :experiment].include?(k.to_sym) ? true : v.blank?} }
  accepts_nested_attributes_for :supplements, :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id, :experiment].include?(k.to_sym) ? true : v.blank?} }
  accepts_nested_attributes_for :hunts,       :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id].include?(k.to_sym) ? true : v.blank?} }
  
  attr_accessible  :forges_attributes, :supplements_attributes, :hunts_attributes
  
  def build_product
    [:forge, :supplement, :hunt].each do |type|
      user.productables(type).each do |result_art|
        (result_art.art_effect.tree[:"#{type}able_number"].to_i-self.send(type.to_s.pluralize).where(:art_effect_id => result_art.art_effect.id).count).times do
          self.send("#{type.to_s.pluralize}").build(:art_effect_id => result_art.art_effect.id)
        end
      end
    end
  end
  
  def hunt_list(kinds)
    user.hunt_list(kinds, day.nil? ? Day.last_day_i : day.day-1)
  end
end
