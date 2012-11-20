class Register::Trade < ActiveRecord::Base
  belongs_to :user

  def build_trade
  end
end
