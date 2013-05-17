class GameData::ArtType < ActiveRecord::Base
  has_many :arts
  attr_accessible :name, :caption, :blossom, :forget, :lv_cap, :train, :max, :form, :rename
  
  validates :name,    :presence => true, :uniqueness => true
  validates :max,     :allow_nil => true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :blossom, :inclusion => { :in => [true, false] }
  validates :forget,  :inclusion => { :in => [true, false] }
  validates :lv_cap,  :inclusion => { :in => [true, false] }
  validates :train,   :inclusion => { :in => [true, false] }
  validates :form,    :inclusion => { :in => [true, false] }
  validates :rename,  :inclusion => { :in => [true, false] }
  
  dnu_document_html :caption
  after_save        :sync_game_data
  
  def character_active
  end
  
  def character_passive
  end
  
  def to_sync_hash
    self.attributes.except("id","created_at","updated_at")
  end
  
  private
  def sync_game_data
    DNU::Data.sync(self)
  end
end
