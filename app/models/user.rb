class User < ActiveRecord::Base
  # 宣言
  has_many :register_mains,        :order => "updated_at DESC", :class_name => "Register::Main"
  has_many :register_trades,       :order => "updated_at DESC", :class_name => "Register::Trade"
  has_many :register_products,     :order => "updated_at DESC", :class_name => "Register::Product"
  
  has_many :register_events,       :order => "updated_at DESC", :class_name => "Register::Event", :include => [:event, :event_step, :event_content]
  
  has_many :register_battles,      :order => "updated_at DESC", :class_name => "Register::Battle"
  has_many :register_duels,        :order => "updated_at DESC", :class_name => "Register::Duel"
  has_many :register_competitions, :order => "updated_at DESC", :class_name => "Register::Competition"
  
  has_many :register_skills,       :order => "updated_at DESC", :class_name => "Register::Skill"
  has_many :register_abilities,    :order => "updated_at DESC", :class_name => "Register::Ability"
  
  has_many :register_messages,     :order => "updated_at DESC", :class_name => "Register::Message"
  has_many :register_communities,  :order => "updated_at DESC", :class_name => "Register::Community"
  has_many :register_characters,   :order => "updated_at DESC", :class_name => "Register::Character"
  has_many :register_images,       :order => "updated_at DESC", :class_name => "Register::Image"
  has_many :register_initials,     :order => "updated_at DESC", :class_name => "Register::Initial"
  
  has_one  :register_make,         :class_name => "Register::Make"
  
  # 結果
  has_many :result_passed_days,   :class_name => "Result::PassedDay"
  
  has_many :result_send_points,   :through => :result_passed_days, :class_name => "Result::SendPoint"
  has_many :result_send_items,    :through => :result_passed_days, :class_name => "Result::SendItem"
  has_many :result_purchases,     :through => :result_passed_days, :class_name => "Result::Purchase"
  has_many :result_forges,        :through => :result_passed_days, :class_name => "Result::Forge"
  has_many :result_supplements,   :through => :result_passed_days, :class_name => "Result::Supplement"
  has_many :result_equips ,       :through => :result_passed_days, :class_name => "Result::Equip"
  has_many :result_trains,        :through => :result_passed_days, :class_name => "Result::Train"
  has_many :result_learns,        :through => :result_passed_days, :class_name => "Result::Learn"
  has_many :result_forgets,       :through => :result_passed_days, :class_name => "Result::Forget"
  has_many :result_blossoms,      :through => :result_passed_days, :class_name => "Result::Blossom"
  has_many :result_disposes,      :through => :result_passed_days, :class_name => "Result::Dispose"
  has_many :result_moves,         :through => :result_passed_days, :class_name => "Result::Move"
  
  has_many :result_events,        :through => :result_passed_days, :class_name => "Result::Event"
  has_many :result_event_states,  :through => :result_events,      :class_name => "Result::EventState", :source => :event_states
  has_many :result_after_moves,   :through => :result_passed_days, :class_name => "Result::AfterMove"
  
  has_many :result_points,        :through => :result_passed_days, :class_name => "Result::Point"
  has_many :result_jobs,          :through => :result_passed_days, :class_name => "Result::Job"
  has_many :result_statuses,      :through => :result_passed_days, :class_name => "Result::Status"
  has_many :result_arts,          :through => :result_passed_days, :class_name => "Result::Art"
  has_many :result_products,      :through => :result_passed_days, :class_name => "Result::Product"
  has_many :result_abilities,     :through => :result_passed_days, :class_name => "Result::Ability"
  has_many :result_battle_values, :through => :result_passed_days, :class_name => "Result::BattleValue"
  has_many :result_skills,        :through => :result_passed_days, :class_name => "Result::Skill"
  has_many :result_inventories,   :through => :result_passed_days, :class_name => "Result::Inventory"
  has_many :result_places,        :through => :result_passed_days, :class_name => "Result::Place"
  
  has_many :through_party_members, :as => :character, :class_name => "Result::PartyMember"
  
  has_many :result_parties,       :through => :through_party_members, :class_name => "Result::Party",       :source => :party
  has_many :result_party_members, :through => :result_parties,        :class_name => "Result::PartyMember", :source => :party_members
  has_many :result_notices,       :through => :result_parties,        :class_name => "Result::Notice",      :source => :notices
  has_many :result_battles,       :through => :result_notices,        :class_name => "Result::Battle",      :source => :battle
  
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
  
  def new_register_events
    self.register_events.where(:day_id => nil)
  end
  
  def form_event_content_ids
    new_register_events.uniq.pluck(:event_content_id)
  end
  
  def register(type, day_i = Day.last_day_i)
    day_arel  = Day.arel_table
    case type.to_sym
    when :event
      self.send("register_#{type.to_s.pluralize}").except(:order).where(day_arel[:day].eq(day_i)).includes(:day)
    else
      self.send("register_#{type.to_s.pluralize}").except(:order).where(day_arel[:day].eq(day_i)).includes(:day).first
    end
  end
  
  def result_character(day_i = Day.last_day_i)
    if self.creation_day == Day.last_day_i
      register_characters.first
    else
      day_i += 1 if self.creation_day == day_i
      
      day_arel  = Day.arel_table
      
      self.register_characters.except(:order).where(day_arel[:day].eq(day_i)).includes(:day).includes(:profile).first
    end
  end
  
  def result_guardian
    register_initials.first.guardian
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
  
  def result_shouts(day_i = Day.last_day_i)
    result(:place, day_i).first.map_tip.where_shouts_by_day_i(day_i)
  end
  
  def result_event_states_by_timing(timing, day_i = Day.last_day_i)
    event_arel      = Result::Event.arel_table
    event_step_arel = GameData::EventStep.arel_table
    
    self.result(:event_state, day_i).where(:state => "途中").
                                     where(event_arel[:state].eq("途中")).includes(:event).
                                     where(event_step_arel[:timing].eq(timing)).includes(:event_step)
  end
  
  def result(type, day_i = Day.last_day_i)
    case type.to_sym
    when :character
      result_character(day_i)
    when :guardian
      result_guardian
    when :map
      result_map(day_i)
    when :shout
      result_shouts(day_i)
    when :state
      result_state(day_i)
    when :trainable
      result_trainable(day_i)
    when :trainable_all
      result_trainable_all(day_i)
    when :place
      day_arel  = Day.arel_table
      self.send("result_#{type.to_s.pluralize}").where(:arrival => true).where(day_arel[:day].eq(day_i)).includes(:day)
    when :party
      day_arel  = Day.arel_table
      if self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day).exists?
        self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day)
      else
        self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i - 1)).includes(:day)
      end
    when :battle
      day_arel  = Day.arel_table
      self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i - 1)).includes(:day)
    else
      day_arel  = Day.arel_table
      self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day)
    end
  end
  
  def new_result(type, data = {}, day_i = Day.last_day_i)
    case type.to_sym
    when :passed_day
      record = self.result_passed_days.build
      data[:day] ||= Day.find_by_day(day_i)
    else
      record = self.result(:passed_day, day_i).last.send("result_#{type.to_s.pluralize}").build
    end
    data.each do |k, v|
      record.send("#{k}=", v) if record.respond_to?("#{k}=")
    end
    record
  end
  
  def create_result!(type, data = {}, day_i = Day.last_day_i)
    record = new_result(type, data, day_i)
    record.save!
    record
  end
  
  def dispose!(number, day_i = Day.last_day_i)
    result_item = nil
    if self.result(:inventory, day_i).where(:number => number).exists?
      result_inventory = self.result(:inventory, day_i).where(:number => number).first
      result_item = result_inventory.item
      unless result_item.dispose_protect
        result_inventory.destroy
      end
    end
    result_item
  end
  
  def blossom!(art, day_i = Day.last_day_i)
    success = false
    if !self.result(:art, day_i).exists?(:art_id => art.id, :forget => false) and self.result(:art, day_i).where(:forget => false).count < 5
      point_arel = GameData::Point.arel_table
      result_point = self.result(:point, day_i).where(point_arel[:name].eq(:GP)).includes(:point).first
      result_point.value -= 10
      if result_point.save
        result_art = result_point.result_arts.where(:art_id=>art.id).first_or_initialize
        result_art.passed_day ||= result_point.passed_day
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
  
  def forget!(art, day_i = Day.last_day_i)
    success = false
    result_art = self.result(:art, day_i).where(:art_id => art.id, :forget => false).first
    if result_art.present?
      result_art.forget = true
      if result_art.save
        point_arel = GameData::Point.arel_table
        result_point = result_art.result_points.where(point_arel[:name].eq(:GP)).includes(:point).first
        result_point.value += result_art.forget_point
        result_point.save!
        success = true
      end
    end
    success
  end
  
  def max_inventory(day_i = Day.last_day_i)
    15
  end
  
  def blank_item_number(day_i = Day.last_day_i)
    ((1..max_inventory(day_i)).to_a - self.result(:inventory, day_i).map{ |r| r.number }).min
  end
  
  def new_inventory(day_i = Day.last_day_i)
    new_result(:inventory, { :number => blank_item_number(day_i) }, day_i)
  end
  
  def add_item!(item, way = nil, day_i = Day.last_day_i)
    success = false
    item_type = item.keys.first
    item_name = item.values.first
    
    result_inventory = new_inventory(day_i)
    if result_inventory.number.present?
      result_item = Result::Item.new_item_by_type_and_name(item_type, item_name, self, way, day_i)
      if result_item.try(:save)
        result_inventory.item = result_item
        result_inventory.save!
        success = result_inventory
      end
    end
    success
  end
  
  def add_event_form!(event_content)
    self.register_events.build do |register_event|
      register_event.event_content = event_content
    end
    self.save
  end
  
  def add_event!(event, day_i = Day.last_day_i)
    success = false
    event_kind = event.keys.first
    event_name = event.values.first
    
    event_arel = GameData::Event.arel_table
    if result(:event, day_i).where(event_arel[:kind].eq(event_kind)).where(event_arel[:name].eq(event_name)).includes(:event).exists?
      result_event = result(:event, day_i).where(event_arel[:kind].eq(event_kind)).where(event_arel[:name].eq(event_name)).includes(:event).first
      result_event.event.event_steps.each do |event_step|
        unless result_event.event_states.where(:event_step_id => event_step.id).exists?
          result_event.event_states.build do |event_state|
            event_state.event_step = event_step
            event_state.state      = "途中"
            event_state.save!
            success = true
          end
        end
      end
    else
      result_event = new_result(:event, {
        :event => GameData::Event.find_by_kind_and_name(event_kind, event_name),
        :state => "途中"
      }, day_i)
      if result_event.event.present?
        result_event.event.event_steps.each do |event_step|
          result_event.event_states.build do |event_state|
            event_state.event_step = event_step
            event_state.state      = "途中"
          end
        end
        result_event.save!
        success = true
      end
    end
    success
  end
  
  def kind
    @@kind ||= GameData::CharacterType.select(:name).where(:player => true).first.name
  end
  
  def tree(day_i = Day.last_day_i)
    @tree ||= {
      :kind  => kind,
      :name  => nickname(day_i),
      :user  => self,
      :day_i => day_i,
      :settings => result(:status,  day_i).map{|r| r.tree } +
                   result(:ability, day_i).map{|r| r.tree } +
                   result(:equip,   day_i).where(:success => true).map{|r| r.tree } +
                   (register(:battle, day_i).try(:battle_settings).try(:map){|r| r.tree } || []) +
                   (register(:battle, day_i).try(:item_skill_settings).try(:map){|r| r.tree }.try(:compact) || [])
    }
  end
  
  def icons
    begin
      self.character.icons.select([:number,:url,:upload_icon_id]).includes(:upload_icon).inject({}){|h,v| h[v.number]=v.url.blank? ? v.upload_icon.icon_url(:icon) : v.url;h}
    rescue
      nil
    end
  end
  
  def name(day_i = Day.last_day_i)
    self.result(:character, day_i).profile.name
  end
  
  def nickname(day_i = Day.last_day_i)
    self.result(:character, day_i).profile.nickname
  end
end
