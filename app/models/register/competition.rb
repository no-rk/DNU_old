class Register::Competition < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  def build_competition
  end
end
