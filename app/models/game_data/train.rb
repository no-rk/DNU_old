class GameData::Train < ActiveRecord::Base
  belongs_to :trainable, :polymorphic => true
  
  def name
    self.trainable.name
  end
  
  def caption
    self.trainable.caption
  end
end
