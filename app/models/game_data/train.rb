class GameData::Train < ActiveRecord::Base
  belongs_to :trainable, :polymorphic => true
end
