class Register::Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  def build_product
  end
end
