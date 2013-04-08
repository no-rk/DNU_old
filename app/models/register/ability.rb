class Register::Ability < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  def build_ability
  end
end
