class Register::Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  attr_accessible :message_users_attributes
  
  has_many :message_users, :order => "id ASC", :dependent => :destroy
  
  accepts_nested_attributes_for :message_users, :reject_if => :all_blank
  
  def build_message
    5.times{self.message_users.build}
  end
end
