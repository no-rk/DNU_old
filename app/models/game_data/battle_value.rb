class GameData::BattleValue < ActiveRecord::Base
  belongs_to :source, :polymorphic => true
  attr_accessible :caption, :name, :has_equip_value, :has_max, :min, :max
  
  validates :name,            :presence => true, :uniqueness => true
  validates :has_max,         :inclusion => { :in => [true, false] }
  validates :has_equip_value, :inclusion => { :in => [true, false] }
  
  dnu_document_html :caption
  after_save        :sync_game_data
  
  def self.has_max_and_equip_value(b_max, b_equip)
    self.where(:has_max =>b_max, :has_equip_value => b_equip).pluck(:name) - GameData::Disease.pluck(:name)
  end
  
  def updateable?
    self.source.nil?
  end
  
  def to_sync_hash
    self.attributes.except("id","source_id","source_type","created_at","updated_at")
  end
  
  private
  def sync_game_data
    if self.updateable?
      DNU::Data.sync(self)
    end
  end
end
