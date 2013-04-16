class Register::Battle < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :equips,          :dependent => :destroy, :as => :battlable
  has_many :battle_settings, :order => "priority ASC", :dependent => :destroy, :as => :battlable
  
  accepts_nested_attributes_for :equips,          :reject_if => proc { |attributes| attributes.all? {|k,v| k.to_sym==:kind ? true : v.blank?} }
  accepts_nested_attributes_for :battle_settings, :reject_if => :no_change_from_default

  attr_accessible :equips_attributes, :battle_settings_attributes

  def build_battle
    (8-self.battle_settings.size).times{self.battle_settings.build}
    
    kinds = ["武器", "頭", "腕", "身体", "装飾"]
    kinds.each do |kind|
      self.equips.build(:kind => kind) unless self.equips.exists?(:kind => kind)
    end
    self.equips.sort_by!{|r| kinds.index(r.kind) }
  end
  
  private
  def no_change_from_default(row)
    # priorityとuse_conditionとfrequency以外が全てブランクの場合リジェクト
    row.all?{ |k,v| [:priority, :use_condition, :frequency].any?{ |x| k.to_sym==x } ? true : v.blank? }
  end
  
end
