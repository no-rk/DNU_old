class User < ActiveRecord::Base
  # 宣言
  has_many :register_mains,        :order => "updated_at DESC", :class_name => "Register::Main"
  has_many :register_trades,       :order => "updated_at DESC", :class_name => "Register::Trade"
  has_many :register_products,     :order => "updated_at DESC", :class_name => "Register::Product"
  
  has_many :register_events,       :order => "updated_at DESC", :class_name => "Register::Event", :include => [:event, :event_step, :event_content]
  
  has_many :register_battles,      :order => "updated_at DESC", :class_name => "Register::Battle", :include => [:battle_type]
  
  has_many :register_pets,         :order => "updated_at DESC", :class_name => "Register::Pet", :include => [:pet]
  has_many :register_skills,       :order => "updated_at DESC", :class_name => "Register::Skill"
  has_many :register_arts,         :order => "updated_at DESC", :class_name => "Register::Art", :include => [:art, :art_effect]
  
  has_many :register_messages,     :order => "updated_at DESC", :class_name => "Register::Message"
  has_many :register_communities,  :order => "updated_at DESC", :class_name => "Register::Community"
  has_many :register_characters,   :order => "updated_at DESC", :class_name => "Register::Character"
  has_many :register_images,       :order => "updated_at DESC", :class_name => "Register::Image"
  has_many :register_initials,     :order => "updated_at DESC", :class_name => "Register::Initial"
  
  has_one  :register_make,         :class_name => "Register::Make"
  
  # 結果
  has_many :result_passed_days,   :class_name => "Result::PassedDay"
  
  has_many :result_send_points,     :through => :result_passed_days, :class_name => "Result::SendPoint"
  has_many :result_send_items,      :through => :result_passed_days, :class_name => "Result::SendItem"
  has_many :result_purchases,       :through => :result_passed_days, :class_name => "Result::Purchase"
  has_many :result_catch_pets,      :through => :result_passed_days, :class_name => "Result::CatchPet"
  has_many :result_forges,          :through => :result_passed_days, :class_name => "Result::Forge"
  has_many :result_supplements,     :through => :result_passed_days, :class_name => "Result::Supplement"
  has_many :result_equips ,         :through => :result_passed_days, :class_name => "Result::Equip", :include => [:battle_type]
  has_many :result_trains,          :through => :result_passed_days, :class_name => "Result::Train"
  has_many :result_learns,          :through => :result_passed_days, :class_name => "Result::Learn"
  has_many :result_forgets,         :through => :result_passed_days, :class_name => "Result::Forget"
  has_many :result_blossoms,        :through => :result_passed_days, :class_name => "Result::Blossom"
  has_many :result_disposes,        :through => :result_passed_days, :class_name => "Result::Dispose"
  has_many :result_moves,           :through => :result_passed_days, :class_name => "Result::Move"
  
  has_many :result_events,          :through => :result_passed_days, :class_name => "Result::Event"
  has_many :result_event_states,    :through => :result_events,      :class_name => "Result::EventState", :source => :event_states
  has_many :result_event_forms,     :through => :result_passed_days, :class_name => "Result::EventForm"
  has_many :result_after_moves,     :through => :result_passed_days, :class_name => "Result::AfterMove"
  
  has_many :result_points,          :through => :result_passed_days, :class_name => "Result::Point"
  has_many :result_statuses,        :through => :result_passed_days, :class_name => "Result::Status"
  has_many :result_arts,            :through => :result_passed_days, :class_name => "Result::Art", :include => [:art]
  has_many :result_battle_values,   :through => :result_passed_days, :class_name => "Result::BattleValue"
  has_many :result_skills,          :through => :result_passed_days, :class_name => "Result::Skill"
  has_many :result_inventories,     :through => :result_passed_days, :class_name => "Result::Inventory"
  has_many :result_pet_inventories, :through => :result_passed_days, :class_name => "Result::PetInventory"
  has_many :result_places,          :through => :result_passed_days, :class_name => "Result::Place"
  
  has_many :through_party_members, :as => :character, :class_name => "Result::PartyMember"
  
  has_many :result_parties,       :through => :through_party_members, :class_name => "Result::Party",       :source => :party
  has_many :result_party_members, :through => :result_parties,        :class_name => "Result::PartyMember", :source => :party_members
  has_many :result_notices,       :through => :result_parties,        :class_name => "Result::Notice",      :source => :notices, :include => [:battle_type]
  has_many :result_battles,       :through => :result_notices,        :class_name => "Result::Battle",      :source => :battle
  has_many :result_enemies,       :through => :result_notices,        :class_name => "Result::Party",       :source => :enemy
  has_many :result_enemy_members, :through => :result_enemies,        :class_name => "Result::PartyMember", :source => :party_members
  
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
  
  def registered?(type, condition = nil)
    if condition.present?
      self.send("register_#{type.to_s.pluralize}").where(:day_id => nil).where(condition).exists?
    else
      self.send("register_#{type.to_s.pluralize}").where(:day_id => nil).exists?
    end
  end
  
  def register_mark(type, condition = nil)
    registered?(type, condition) ? "●" : "○"
  end
  
  def productables(type, day_i = Day.last_day_i)
    self.result(:art, day_i).merge(GameData::Art.productables(type))
  end
  
  def hunt_list(kinds, day_i = Day.last_day_i)
    self.result(:enemy_member, day_i).find_all{|r| kinds.include?(r.character.kind)}.each.with_index(1).inject({}){|h,(r,i)| h.tap{ h["[#{i}] #{r.character.name}#{p_correction(r.correction)}"] = r.id } }
  end
  
  def form(type)
    case type.to_sym
    when :battle
      self.result(:notice).group(:battle_type_id).map{|r| r.battle_type}
    when :pet
      self.result(:pet_inventory).map{|r| r.pet}
    when :event
      self.result(:event_form).map{|r| r.event_content}
    when :art
      self.result(:art).merge(GameData::Art.form).where(:forget => false).map{ |r| r.send(type) }
    else
      self.result(type).where(:forget => false).map{ |r| r.send(type) }
    end
  end
  
  def next_forms(type)
    case type.to_sym
    when :event
      sub_query = self.send("register_#{type.to_s.pluralize}").as(type.to_s)
      "Register::#{type.to_s.camelize}".constantize.select(Arel.star).from(sub_query).group(sub_query["#{type}_content_id"])
    when :battle
      sub_query = self.send("register_#{type.to_s.pluralize}").as(type.to_s)
      "Register::#{type.to_s.camelize}".constantize.select(Arel.star).from(sub_query).group(sub_query["#{type}_type_id"])
    when :skill, :art
      sub_query = self.send("register_#{type.to_s.pluralize}").as(type.to_s)
      "Register::#{type.to_s.camelize}".constantize.select(Arel.star).from(sub_query).group(sub_query["#{type}_id"])
    else
      [self.send("register_#{type.to_s.pluralize}").first].compact
    end
  end
  
  def register(type, day_i = Day.last_day_i)
    case type.to_sym
    when :event, :battle, :skill, :art
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
      
      self.register_characters.except(:order).where(day_arel[:day].eq(day_i)).includes(:day).includes(:profile).first
    end
  end
  
  def result_guardian
    register_initials.first.guardian
  end
  
  def result_state(day_i = Day.last_day_i)
    state = {}
    state = result(:art,     day_i).where(:forget => false).includes(:art    ).inject(state){ |h,r| h.tap{ h[r.art.name]     = r.effective_lv } }
    state
  end
  
  def result_trainable(day_i = Day.last_day_i)
    train_arel = GameData::Train.arel_table
    train = {}
    train = result(:status,  day_i).where(train_arel[:visible].eq(true)).includes(:status,  :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:art,     day_i).where(train_arel[:visible].eq(true)).where(:forget => false).includes(:art,     :train).inject(train){ |h,r| h.tap{ h[r.name] = r.train.id } }
    train
  end
  
  def result_trainable_all(day_i = Day.last_day_i)
    train_arel = GameData::Train.arel_table
    train = {}
    train = result(:status,  day_i).where(train_arel[:visible].eq(true)).includes(:status,  :train).inject(train){ |h,r| h.tap{ h[r.nickname] = r.train.id } }
    train = result(:art,     day_i).where(train_arel[:visible].eq(true)).includes(:art,     :train).inject(train){ |h,r| h.tap{ h[r.name] = r.train.id } }
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
      self.send("result_#{type.to_s.pluralize}").where(:arrival => true).where(day_arel[:day].eq(day_i)).includes(:day)
    when :party
      if self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day).exists?
        self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i)).includes(:day)
      else
        self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i - 1)).includes(:day)
      end
    when :battle
      self.send("result_#{type.to_s.pluralize}").where(day_arel[:day].eq(day_i - 1)).includes(:day)
    else
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
  
  def add_art!(art, lv = 1, day_i = Day.last_day_i)
    success = false
    art_type = art.keys.first
    art_name = art.values.first
    
    model_art = GameData::Art.find_by_type_and_name(art_type, art_name).first
    if model_art.present?
      result_art = self.result(:art, day_i).merge(GameData::Art.find_by_type_and_name(art_type, art_name)).first
      if result_art.present?
        if result_art.forget
          result_art.lv     = lv
          result_art.forget = false
          result_art.save!
          success = true
        end
      else
        success = create_result!(:art, {
          :art        => model_art,
          :lv         => lv,
          :lv_exp     => 0,
          :lv_cap     => model_art.art_type.lv_cap ? 5 : nil,
          :lv_cap_exp => model_art.art_type.lv_cap ? 0 : nil,
          :forget     => false
        }, day_i)
      end
    end
    success
  end
  
  def add_art?(art, day_i = Day.last_day_i)
    if self.result(:art, day_i).exists?(:art_id => art.id, :forget => false)
      # 習得済み
      false
    elsif art.art_type.max.nil?
      # 未修得で最大技能数存在しない
      true
    elsif self.result(:art, day_i).where(:forget => false).merge(GameData::Art.find_all_by_type(art.type)).count < art.art_type.max
      # 未修得で最大習得数に達していない
      true
    else
      false
    end
  end
  
  def blossom!(art, day_i = Day.last_day_i)
    success = false
    if add_art?(art, day_i)
      point_arel = GameData::Point.arel_table
      result_point = self.result(:point, day_i).where(point_arel[:name].eq(art.train_point.name)).includes(:point).first
      result_point.value -= art.blossom_point
      if result_point.save
        success = add_art!({ art.type => art.name }, 1, day_i)
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
        result_point = result_art.result_points.where(point_arel[:name].eq(art.train_point.name)).includes(:point).first
        result_point.value += result_art.forget_point
        result_point.save!
        success = result_art
      end
    end
    success
  end
  
  def max_inventory(day_i = Day.last_day_i)
    15
  end
  
  def max_pet_inventory(pet_kind, day_i = Day.last_day_i)
    3
  end
  
  def blank_item_number(day_i = Day.last_day_i)
    ((1..max_inventory(day_i)).to_a - self.result(:inventory, day_i).map{ |r| r.number }).min
  end
  
  def blank_pet_number(pet_kind, day_i = Day.last_day_i)
    ((1..max_pet_inventory(pet_kind, day_i)).to_a - self.result(:pet_inventory, day_i).where(:kind => pet_kind).map{ |r| r.number }).min
  end
  
  def new_inventory(day_i = Day.last_day_i)
    new_result(:inventory, { :number => blank_item_number(day_i) }, day_i)
  end
  
  def new_pet_inventory(pet_kind, day_i = Day.last_day_i)
    new_result(:pet_inventory, {
      :character_type => GameData::CharacterType.where(:name => pet_kind).first,
      :number => blank_pet_number(pet_kind, day_i)
    }, day_i)
  end
  
  def add_item!(item, way = nil, day_i = Day.last_day_i)
    success = nil
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
  
  def add_pet!(pet, correction = 0, way = nil, day_i = Day.last_day_i)
    success = nil
    pet_kind = pet.keys.first
    pet_name = pet.values.first
    
    result_inventory = new_pet_inventory(pet_kind, day_i)
    if result_inventory.number.present?
      result_pet = Result::Pet.new_pet_by_kind_and_name_and_correction(pet_kind, pet_name, correction, self, way, day_i)
      if result_pet.try(:save)
        result_inventory.pet = result_pet
        result_inventory.save!
        success = result_inventory
      end
    end
    success
  end
  
  def add_event_form!(event_content, day_i = Day.last_day_i)
    self.create_result!(:event_form, {
      :event_content => event_content
    }, day_i)
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
  
  def status_settings(day_i = Day.last_day_i)
    result(:status, day_i).map{|r| r.tree }
  end
  
  def art_settings(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    result(:art, day_i).map{|r| r.tree }.compact
  end
  
  def equip_settings(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    result(:equip, day_i).where(:success => true).where(battle_type_arel[:name].eq(battle_type)).map{|r| r.tree }
  end
  
  def skill_settings(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    register(:battle, day_i).where(battle_type_arel[:name].eq(battle_type)).map{|r| r.battle_settings}.flatten.map{|r| r.tree }
  end
  
  def item_skill_settings(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    register(:battle, day_i).where(battle_type_arel[:name].eq(battle_type)).map{|r| r.item_skill_settings}.flatten.map{|r| r.tree }.compact
  end
  
  def pet_settings(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    result(:pet_inventory).map{|r| {:pno => r.pet_id, :battle_type => battle_type}}
  end
  
  def tree(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    @tree ||= {}
    @tree[day_i] ||= {
      :kind  => kind,
      :name  => nickname(day_i),
      :user  => self,
      :day_i => day_i,
      :settings => status_settings(day_i) +
                   art_settings(day_i, battle_type) +
                   equip_settings(day_i, battle_type) +
                   skill_settings(day_i, battle_type) +
                   item_skill_settings(day_i, battle_type),
      :pets => pet_settings(day_i, battle_type)
    }
  end
  
  def icons
    if @icons.nil?
      @icons = self.register_characters.first.icons.select([:number,:url,:upload_icon_id]).includes(:upload_icon).inject({}){|h,r| h.tap{ h[r.number]= (r.url.blank? ? r.upload_icon.icon_url(:icon) : r.url)} }
    end
    @icons
  end
  
  def name(day_i = Day.last_day_i)
    self.result(:character, day_i).profile.name
  end
  
  def nickname(day_i = Day.last_day_i)
    self.result(:character, day_i).profile.nickname
  end
  
  private
  def day_arel
    @day_arel ||= Day.arel_table
  end
  
  def battle_type_arel
    @battle_type_arel ||= GameData::BattleType.arel_table
  end
  
  def p_correction(correction)
    unless correction.to_i==0
      %Q| #{sprintf("%+d", correction.to_i)}|
    end
  end
end
