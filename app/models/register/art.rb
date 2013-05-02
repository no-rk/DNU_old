class Register::Art < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :art, :class_name => "GameData::Art"
  attr_accessible :art_id, :art_name_attributes
  
  has_one :art_effect, :through => :art, :class_name => "GameData::ArtEffect"
  
  has_one  :art_name, :dependent => :destroy
  
  accepts_nested_attributes_for :art_name, :reject_if => :all_blank
  
  def build_art
    self.build_art_name if self.art_name.nil?
  end
end
