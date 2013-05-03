class GameData::Train < ActiveRecord::Base
  belongs_to :trainable, :polymorphic => true
  attr_accessible :name
  
  validates :name, :presence => true, :uniqueness => true
  
  before_validation :set_game_data
  
  def caption
    self.trainable.caption
  end
  
  def self.name_exists?(model)
    if model.new_record?
      self.where(arel_table[:name].eq(model.name)).exists?
    else
      self.where(arel_table[:name].eq(model.name)).
           where(arel_table[:trainable_type].eq(model.class.name).and(arel_table[:trainable_id].eq(model.id)).not).exists?
    end
  end
  
  private
  def set_game_data
    self.name = self.trainable.name
  end
end
