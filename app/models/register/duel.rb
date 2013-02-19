class Register::Duel < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  def build_duel
  end
end
