class GameData::LearningCondition < ActiveRecord::Base
  belongs_to :learnable, :polymorphic => true
  attr_accessible :condition_group, :lv, :name
end
