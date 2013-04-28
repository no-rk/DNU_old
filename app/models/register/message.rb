class Register::Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  
  def build_message
  end
end
