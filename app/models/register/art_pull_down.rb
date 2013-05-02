class Register::ArtPullDown < ActiveRecord::Base
  belongs_to :art
  attr_accessible :pull_down
end
