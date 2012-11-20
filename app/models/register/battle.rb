class Register::Battle < ActiveRecord::Base
  belongs_to :user

  def build_battle
  end
end
