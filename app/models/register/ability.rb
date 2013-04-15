class Register::Ability < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  
  has_many :ability_confs, :order => "game_data_ability_id ASC", :dependent => :destroy
  accepts_nested_attributes_for :ability_confs
  attr_accessible :ability_confs_attributes
  
  has_many :ability_names,    :through => :ability_confs
  has_many :ability_settings, :through => :ability_confs
  
  def build_ability
  end
end
