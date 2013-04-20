class GameData::Sup < ActiveRecord::Base
  attr_accessible :definition, :name
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def self.sup_comp(a, b)
    a ||= {}
    b ||= {}
    if a[:name].present? and b[:name].present?
      a_id  = self.select(:id).find_by_name(a[:name].to_s).id
      a_lv  = a[:lv].to_i
      
      b_id  = self.select(:id).find_by_name(b[:name].to_s).id
      b_lv  = b[:lv].to_i
      
      total = self.count.to_i
      
      c_id = (a_id + a_lv + b_id + b_lv)%total + 1
      c_lv = ((a_lv + b_lv)/2).to_i
      
      { :name => self.select(:name).find(c_id).name, :lv => (c_lv==0 ? nil : c_lv) }
    elsif a[:name].present?
      a
    end
  end
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      self.name = tree[:name].to_s
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
