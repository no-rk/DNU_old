class Register::InitArt < ActiveRecord::Base
  belongs_to :initial
  belongs_to :art, :class_name => "GameData::Art"
  attr_accessible :type
  attr_writer :type
  
  has_one :art_type, :through => :art, :class_name => "GameData::ArtType"
  
  def name
    self.art.try(:name)
  end
  
  def type
    @type || self.art_type.try(:name)
  end
  
  validates :art, :presence => true
  
  attr_accessible :art_id
end
