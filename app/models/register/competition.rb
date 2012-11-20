class Register::Competition < ActiveRecord::Base
  belongs_to :user

  def build_competition
  end
end
