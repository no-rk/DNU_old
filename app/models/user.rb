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

  has_one  :ability     , :order => "updated_at DESC", :class_name => "Register::Ability"
  has_many :abilities   , :order => "updated_at DESC", :class_name => "Register::Ability"

  has_one  :character   , :order => "updated_at DESC", :class_name => "Register::Character"
  has_many :characters  , :order => "updated_at DESC", :class_name => "Register::Character"
  has_one  :image       , :order => "updated_at DESC", :class_name => "Register::Image"
  has_many :images      , :order => "updated_at DESC", :class_name => "Register::Image"
  has_one  :initial     , :order => "updated_at DESC", :class_name => "Register::Initial"
  has_many :initials    , :order => "updated_at DESC", :class_name => "Register::Initial"

  has_one  :make        , :order => "updated_at DESC", :class_name => "Register::Make"
  has_many :makes       , :order => "updated_at DESC", :class_name => "Register::Make"

  has_many :result_send_points, :class_name => "Result::SendPoint"
  has_many :result_trains,      :class_name => "Result::Train"
  has_many :result_learns,      :class_name => "Result::Learn"
  has_many :result_forgets,     :class_name => "Result::Forget"
  has_many :result_blossoms,    :class_name => "Result::Blossom"
  has_many :result_moves,       :class_name => "Result::Move"
  
  has_many :through_party_members, :as => :character, :class_name => "Result::PartyMember"
  has_many :result_parties, :through => :through_party_members, :class_name => "Result::Party", :source => :party
  has_many :result_notices, :through => :result_parties, :class_name => "Result::Notice", :source => :notices
  
  has_many :result_places,      :class_name => "Result::Place"
  has_many :result_inventories, :class_name => "Result::Inventory"
  has_many :result_points,    :as => :character, :class_name => "Result::Point"
  has_many :result_statuses,  :as => :character, :class_name => "Result::Status"
  has_many :result_jobs,      :as => :character, :class_name => "Result::Job"
  has_many :result_arts,      :as => :character, :class_name => "Result::Art"
  has_many :result_products,  :as => :character, :class_name => "Result::Product"
  has_many :result_abilities, :as => :character, :class_name => "Result::Ability"
  has_many :result_skills,    :as => :character, :class_name => "Result::Skill"

  scope :new_commer,   lambda{ where(arel_table[:creation_day].eq(Day.last_day_i)) }
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
  
  def register(type, day_i = Day.last_day_i)
    day_arel  = Day.arel_table
    
    self.send("#{type.to_s.pluralize}").except(:order).where(day_arel[:day].eq(day_i)).includes(:day).first
  end
  
  def result_character(day_i = Day.last_day_i)
    if self.creation_day == Day.last_day_i
      character
    else
      day_i += 1 if self.creation_day == day_i
      
      day_arel  = Day.arel_table
      
      self.characters.except(:order).where(day_arel[:day].eq(day_i)).includes(:day).includes(:profile).first
    end
  end
  
  def result_guardian
    initial.guardian
  end
  
  def result_state(day_i = Day.last_day_i)
    state = {}
    state = result(:job,     day_i).where(:forget => false).includes(:job    ).inject(state){ |h,r| h.tap{ h[r.job.name]     = r.lv_cap.nil? ? r.lv : [r.lv, r.lv_cap].min } }
    state = result(:art,     day_i).where(:forget => false).includes(:art    ).inject(state){ |h,r| h.tap{ h[r.art.name]     = r.lv_cap.nil? ? r.lv : [r.lv, r.lv_cap].min } }
    state = result(:product, day_i).where(:forget => false).includes(:product).inject(state){ |h,r| h.tap{ h[r.product.name] = r.lv_cap.nil? ? r.lv : [r.lv, r.lv_cap].min } }
    state = result(:ability, day_i).where(:forget => false).includes(:ability).inject(state){ |h,r| h.tap{ h[r.ability.name] = r.lv_cap.nil? ? r.lv : [r.lv, r.lv_cap].min } }
    state
  end
  
  def result_trainable(day_i = Day.last_day_i)
    train_arel = GameData::Train.arel_table
    train = {}
    train = result(:status,  day_i).where(train_arel[:visible].eq(true)).includes(:status,  :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:job,     day_i).where(:forget => false).where(train_arel[:visible].eq(true)).includes(:job,     :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:art,     day_i).where(:forget => false).where(train_arel[:visible].eq(true)).includes(:art,     :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:product, day_i).where(:forget => false).where(train_arel[:visible].eq(true)).includes(:product, :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:ability, day_i).where(:forget => false).where(train_arel[:visible].eq(true)).includes(:ability, :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train
  end
  
  def result_trainable_all(day_i = Day.last_day_i)
    train_arel = GameData::Train.arel_table
    train = {}
    train = result(:status,  day_i).where(train_arel[:visible].eq(true)).includes(:status,  :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:job,     day_i).where(train_arel[:visible].eq(true)).includes(:job,     :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:art,     day_i).where(train_arel[:visible].eq(true)).includes(:art,     :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:product, day_i).where(train_arel[:visible].eq(true)).includes(:product, :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:ability, day_i).where(train_arel[:visible].eq(true)).includes(:ability, :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train
  end
  
  def result_map(day_i = Day.last_day_i)
    Result::Map.find_by_name_and_day_i(result(:place, day_i).first.map.name, day_i)
  end
  
  def result(type, day_i = Day.last_day_i)
    case type.to_sym
    when :character
      result_character(day_i)
    when :guardian
      result_guardian
    when :map
      result_map(day_i)
    when :state
      result_state(day_i)
    when :trainable
      result_trainable(day_i)
    when :trainable_all
      result_trainable_all(day_i)
    when :place
      day_arel  = Day.arel_table
      self.send("result_#{type.to_s.pluralize}").where(:arrival => true).where(day_arel[:day].eq(day_i)).includes(:day)
    else
      day_arel  = Day.arel_table
      self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day)
    end
  end
  
  def blossom!(art, day = Day.last)
    success = false
    if !self.result(:art, day.day).exists?(:art_id => art.id, :forget => false) and self.result(:art, day.day).where(:forget => false).count < 5
      point_arel = GameData::Point.arel_table
      result_point = self.result(:point, day.day).where(point_arel[:name].eq(:GP)).includes(:point).first
      result_point.value -= 10
      if result_point.save
        result_art = Result::Art.where(
          :character_id => self.id,
          :character_type => :User,
          :day_id=>day.id,
          :art_id=>art.id
        ).first_or_initialize
        result_art.lv = 1
        result_art.lv_exp ||= 0
        result_art.lv_cap ||= 5
        result_art.lv_cap_exp ||= 0
        result_art.forget = false
        result_art.save!
        success = true
      end
    end
    success
  end
  
  def forget!(art, day = Day.last)
    success = false
    result_art = self.result(:art, day.day).where(:art_id => art.id, :forget => false).first
    if result_art.present?
      result_art.forget = true
      if result_art.save
        point_arel = GameData::Point.arel_table
        result_point = self.result(:point, day.day).where(point_arel[:name].eq(:GP)).includes(:point).first
        result_point.value += result_art.forget_point
        result_point.save!
        success = true
      end
    end
    success
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
