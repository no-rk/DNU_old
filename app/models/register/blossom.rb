class Register::Blossom < ActiveRecord::Base
  belongs_to :main
  belongs_to :train, :class_name => "GameData::Train"
  attr_accessible :train_id
end
