class User < ActiveRecord::Base
  has_one  :main      , :order => "updated_at DESC", :class_name => "Register::Main"
  has_many :mains     , :order => "updated_at DESC", :class_name => "Register::Main"
  has_one  :trade     , :order => "updated_at DESC", :class_name => "Register::Trade"
  has_many :trades    , :order => "updated_at DESC", :class_name => "Register::Trade"
  has_one  :product   , :order => "updated_at DESC", :class_name => "Register::Product"
  has_many :products  , :order => "updated_at DESC", :class_name => "Register::Product"
  has_one  :character , :order => "updated_at DESC", :class_name => "Register::Character"
  has_many :characters, :order => "updated_at DESC", :class_name => "Register::Character"
  has_one  :initial   , :order => "updated_at DESC", :class_name => "Register::Initial"
  has_many :initials  , :order => "updated_at DESC", :class_name => "Register::Initial"
  has_one  :make      , :order => "updated_at DESC", :class_name => "Register::Make"
  has_many :makes     , :order => "updated_at DESC", :class_name => "Register::Make"

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
