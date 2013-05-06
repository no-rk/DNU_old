class Register::Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :forges,      :order => "id ASC", :dependent => :destroy, :as => :productable
  has_many :supplements, :order => "id ASC", :dependent => :destroy, :as => :productable

  accepts_nested_attributes_for :forges,      :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id, :item_type_index, :experiment].include?(k.to_sym) ? true : v.blank?} }
  accepts_nested_attributes_for :supplements, :reject_if => proc { |attributes| attributes.all?{|k,v| [:art_effect_id, :experiment].include?(k.to_sym) ? true : v.blank?} }

  attr_accessible  :forges_attributes, :supplements_attributes

  def build_product
    user.forgeables.each do |result_art|
      (result_art.art_effect.tree[:forgeable_number].to_i-self.forges.where(:art_effect_id => result_art.art_effect.id).count).times do
        self.forges.build(:art_effect_id => result_art.art_effect.id)
      end
    end
    user.supplementables.each do |result_art|
      (result_art.art_effect.tree[:supplementable_number].to_i-self.supplements.where(:art_effect_id => result_art.art_effect.id).count).times do
        self.supplements.build(:art_effect_id => result_art.art_effect.id)
      end
    end
  end
end
