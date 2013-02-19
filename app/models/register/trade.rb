class Register::Trade < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  def build_trade
  end
end
