class GameData::Status < ActiveRecord::Base
  has_one :train, :as => :trainable, :dependent => :destroy
  attr_accessible :definition, :name, :caption
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      self.name    = tree[:name].to_s
      self.caption = tree[:name].to_s
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
    DNU::Data.trainable(self, true)
  end
end
