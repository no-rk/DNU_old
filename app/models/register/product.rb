class Register::Product < ActiveRecord::Base
  belongs_to :user

  def build_product
  end
end
