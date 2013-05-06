class Result::Party < ActiveRecord::Base
  belongs_to :day
  has_many :party_members, :dependent => :destroy
  has_many :notices, :dependent => :destroy
  attr_accessible :caption, :kind, :name
  
  validates :day,  :presence => true
  validates :kind, :inclusion => { :in => ["battle"] }
  
  scope :where_user_ids_and_day_i, lambda{ |user_ids, day_i|
    pm_arel = Result::PartyMember.arel_table
    day_arel = Day.arel_table
    
    where(pm_arel[:character_type].eq(:User)).
    where(pm_arel[:character_id].in(user_ids)).includes(:party_members).
    where(day_arel[:day].eq(day_i)).includes(:day).
    uniq
  }
  
  scope :already_make, lambda{ 
    day_i = Day.last_day_i
    user_ids = User.already_make.pluck(:id)
    if where_user_ids_and_day_i(user_ids, day_i).exists?
      where_user_ids_and_day_i(user_ids, day_i)
    else
      where_user_ids_and_day_i(user_ids, day_i - 1)
    end
  }
  
  def party_users
    party_members.where(:character_type => :User)
  end
  
  def set_item_skill!(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    party_users.find_each do |party_user|
      party_user.character.register(:battle, day_i).where(battle_type_arel[:name].eq(battle_type)).first.try(:item_skill_settings).try(:each) do |item_skill_setting|
        item_skill_setting.set_item!
      end
    end
  end
  
  def characters(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    @characters ||= DNU::Fight::State::Characters.new(pt_settings_tree(day_i, battle_type))
  end
  
  def pt_settings_tree(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    @pt_settings ||= { :settings => [definition_tree(day_i, battle_type)] }
  end
  
  def definition_tree(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    @definition_tree ||= {
      :pt_name    => nickname,
      :pt_caption => caption,
      :members    => party_members.map{|r| r.setting_tree(day_i, battle_type) }
    }
  end
  
  def add_notice!(party_tree, battle_type = GameData::BattleType.event.name)
    unless self.notices.exists?
      self.notices.build do |notice|
        notice.battle_type = GameData::BattleType.where(:name => battle_type).first
        notice.enemy       = self.class.new_from_definition_tree(party_tree)
      end
      self.save!
    end
  end
  
  def place
    if party_members.where(:character_type => :User).exists?
      party_members.where(:character_type => :User).first.character.result(:place, day.day).first
    end
  end
  
  def enemy_territory
    place.try(:enemy_territory)
  end
  
  def nickname
    name || "第#{id}PT"
  end
  
  def self.new_from_definition_tree(tree, battle_kind = :battle, day = Day.last)
    result_party = self.new(:name => tree[:pt_name], :caption => tree[:pt_caption])
    result_party.kind = battle_kind.to_s
    result_party.day = day
    
    tree[:members].each do |member|
      (member[:number] || 1).times do
        result_party.party_members.build do |result_party_member|
          if member[:eno].present?
            result_party_member.character = User.find(member[:eno])
          else
            result_party_member.character = GameData::Character.find_by_kind_and_name(member[:kind], member[:name])
          end
          result_party_member.correction = member[:correction].to_i
        end
      end
    end
    result_party
  end
  
  def self.new_from_tree(tree, battle_kind = :battle, day = Day.last)
    result_party = self.new(:name => tree[:pt_name].to_s, :caption => tree[:pt_caption].to_s)
    result_party.kind = battle_kind.to_s
    result_party.day = day
    
    tree[:members].each do |member|
      result_party.party_members.build do |result_party_member|
        result_party_member.character  = member[:character]
        result_party_member.correction = member[:correction]
      end
    end
    result_party
  end
  
  private
  def day_arel
    @day_arel ||= Day.arel_table
  end
  
  def battle_type_arel
    @battle_type_arel ||= GameData::BattleType.arel_table
  end
end
