class GameData::Equip < ActiveRecord::Base
  belongs_to :item_type
  attr_accessible :definition, :kind, :name
  
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  def tree
    @tree ||= DNU::Data.parse_from_model(self)
  end
end
