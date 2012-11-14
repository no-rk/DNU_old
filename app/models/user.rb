class User < ActiveRecord::Base
  has_many :mains,      :class_name => "Register::Main"
  has_many :trades,     :class_name => "Register::Trade"
  has_many :products,   :class_name => "Register::Product"
  has_many :characters, :class_name => "Register::Character"
  has_many :initials,   :class_name => "Register::Initial"
  has_many :makes,      :class_name => "Register::Make"

  acts_as_messageable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(id) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
