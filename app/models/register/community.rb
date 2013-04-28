class Register::Community < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  
  def build_community
  end
end
