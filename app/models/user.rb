class User < ActiveRecord::Base
  has_one  :main        , :order => "updated_at DESC", :class_name => "Register::Main"
  has_many :mains       , :order => "updated_at DESC", :class_name => "Register::Main"
  has_one  :trade       , :order => "updated_at DESC", :class_name => "Register::Trade"
  has_many :trades      , :order => "updated_at DESC", :class_name => "Register::Trade"
  has_one  :product     , :order => "updated_at DESC", :class_name => "Register::Product"
  has_many :products    , :order => "updated_at DESC", :class_name => "Register::Product"

  has_one  :battle      , :order => "updated_at DESC", :class_name => "Register::Battle"
  has_many :battles     , :order => "updated_at DESC", :class_name => "Register::Battle"
  has_one  :duel        , :order => "updated_at DESC", :class_name => "Register::Duel"
  has_many :duels       , :order => "updated_at DESC", :class_name => "Register::Duel"
  has_one  :competition , :order => "updated_at DESC", :class_name => "Register::Competition"
  has_many :competitions, :order => "updated_at DESC", :class_name => "Register::Competition"

  has_one  :character   , :order => "updated_at DESC", :class_name => "Register::Character"
  has_many :characters  , :order => "updated_at DESC", :class_name => "Register::Character"
  has_one  :image       , :order => "updated_at DESC", :class_name => "Register::Image"
  has_many :images      , :order => "updated_at DESC", :class_name => "Register::Image"
  has_one  :initial     , :order => "updated_at DESC", :class_name => "Register::Initial"
  has_many :initials    , :order => "updated_at DESC", :class_name => "Register::Initial"

  has_one  :make        , :order => "updated_at DESC", :class_name => "Register::Make"
  has_many :makes       , :order => "updated_at DESC", :class_name => "Register::Make"

  has_many :result_statuses, :as => :character, :class_name => "Result::Status"
  has_many :result_jobs,     :as => :character, :class_name => "Result::Job"
  has_many :result_arts,     :as => :character, :class_name => "Result::Art"

  scope :already_make, lambda{ where(arel_table[:creation_day].lt(Day.last_day_i)) }

  acts_as_tagger
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
  
  def result_character(day_i = Day.last_day_i)
    if self.creation_day == Day.last_day_i
      character
    else
      day_i += 1 if self.creation_day == day_i
      
      user_arel = User.arel_table
      day_arel  = Day.arel_table
      character_arel = Register::Character.arel_table
      
      Register::Character.where(user_arel[:id].eq(self.id)).includes(:user).
                          where(day_arel[:day].eq(day_i)).includes(:day).
                          order(character_arel[:id].desc).limit(1).first
    end
  end
  
  def result(type, day_i = Day.last_day_i)
    day_arel  = Day.arel_table
    
    self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day)
  end
  
  def icons
    begin
      self.character.icons.select([:number,:url,:upload_icon_id]).includes(:upload_icon).inject({}){|h,v| h[v.number]=v.url.blank? ? v.upload_icon.icon_url(:icon) : v.url;h}
    rescue
      nil
    end
  end
  
  def name
    self.character.profile.name
  end
end
