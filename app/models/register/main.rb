class Register::Main < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  def build_main
  end
end
