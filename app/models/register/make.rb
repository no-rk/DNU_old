class Register::Make < ActiveRecord::Base
  belongs_to :user
end
