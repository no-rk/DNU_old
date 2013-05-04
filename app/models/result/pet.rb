class Result::Pet < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :way,    :polymorphic => true
  belongs_to :plan,   :class_name => "GameData::Character"
  belongs_to :kind,   :class_name => "GameData::CharacterType"
  belongs_to :source, :class_name => "Result::Pet"
  attr_accessible :dispose_protect, :send_protect
  
  has_many :pet_statuses, :dependent => :destroy, :include => [:day]
  has_many :pet_arts,     :dependent => :destroy, :include => [:day]
  has_many :pet_sups,     :dependent => :destroy, :include => [:day]
  has_many :pet_skills,   :dependent => :destroy, :include => [:day]
  
  has_many :register_pets, :class_name => "Register::Pet", :include => [:day]
  
  has_many :result_pet_inventories, :class_name => "Result::PetInventory", :include => [:day]
  
  validates :user,            :presence => true
  validates :day,             :presence => true
  validates :kind,            :presence => true
  validates :dispose_protect, :inclusion => { :in => [true, false] }
  validates :send_protect,    :inclusion => { :in => [true, false] }
  
  def self.new_pet_by_data(pet_data, user, way = nil, day_i = Day.last_day_i)
    day = Day.find_by_day(day_i)
    result_pet = self.new
    result_pet.kind = GameData::CharacterType.where(:name => pet_data[:kind]).first
    
    pet_data[:settings].each do |(k,v)|
      case k
      when :pet_status
        result_pet.pet_statuses.build do |pet_status|
          pet_status.user   = user
          pet_status.day    = day
          pet_status.way    = way
          pet_status.status = GameData::Status.where(:name => v[:name]).first
          pet_status.count  = v[:count].to_i
          pet_status.bonus  = v[:bonus].to_i
          pet_status.source = v[:source] if v[:source].present?
        end
      when :pet_art
        result_pet.pet_arts.build do |pet_art|
          pet_art.user   = user
          pet_art.day    = day
          pet_art.way    = way
          pet_art.number = v[:number]
          pet_art.art    = GameData::Art.where(:name => v[:name]).first
          pet_art.lv     = v[:lv]
          pet_art.source = v[:source] if v[:source].present?
        end
      when :pet_sup
        result_pet.pet_sups.build do |pet_sup|
          pet_sup.user   = user
          pet_sup.day    = day
          pet_sup.way    = way
          pet_sup.number = v[:number]
          pet_sup.sup    = GameData::Sup.where(:name => v[:name]).first
          pet_sup.lv     = v[:lv]
          pet_sup.source = v[:source] if v[:source].present?
        end
      when :pet_skill
        result_pet.pet_skills.build do |pet_skill|
          pet_skill.user   = user
          pet_skill.day    = day
          pet_skill.way    = way
          pet_skill.number = v[:number]
          pet_skill.skill  = GameData::Skill.where(:name => v[:name]).first
          pet_skill.source = v[:source] if v[:source].present?
        end
      end
    end
    
    result_pet
  end
  
  def self.new_pet_by_kind_and_name_and_correction(pet_kind, pet_name, correction, user, way = nil, day_i = Day.last_day_i)
    pet_plan = GameData::Character.where(:kind => pet_kind, :name => pet_name).first
    
    if pet_plan.present?
      pet_data = pet_plan.pet_data(correction)
      
      result_pet = self.new_pet_by_data(pet_data, user, way, day_i)
      result_pet.user            = user
      result_pet.day             = Day.find_by_day(day_i)
      result_pet.way             = way
      result_pet.plan            = pet_plan
      result_pet.dispose_protect = pet_data[:dispose_protect].present?
      result_pet.send_protect    = pet_data[:send_protect].present?
    end
    result_pet
  end
  
  def name
    "[#{self.plan.kind}][#{self.pet_inventory.number}]#{self.plan.name}"
  end
  
  def register_pet(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    
    register_pets.where(day_arel[:day].eq(day_i)).first
  end
  
  def profile(day_i = Day.last_day_i)
    register_pet(day_i).try(:profile)
  end
  
  def battle_settings(day_i = Day.last_day_i)
    register_pet(day_i).try(:battle_settings) || []
  end
  
  def pet_inventory(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    
    result_pet_inventories.where(day_arel[:day].eq(day_i)).first
  end
  
  def pet_status(status_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_status_arel = Result::PetStatus.arel_table
    
    pet_statuses.where(:status_id => status_id).where(day_arel[:day].lteq(day_i)).
                 order(day_arel[:day].desc, pet_status_arel[:id].desc).limit(1).includes(:user).includes(:status).first
  end
  
  def pet_art(n, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_art_arel = Result::PetArt.arel_table
    
    pet_arts.where(:number => n).where(day_arel[:day].lteq(day_i)).
             order(day_arel[:day].desc, pet_art_arel[:id].desc).limit(1).includes(:user).includes(:art).first
  end
  
  def pet_sup(n, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_sup_arel = Result::PetSup.arel_table
    
    pet_sups.where(:number => n).where(day_arel[:day].lteq(day_i)).
             order(day_arel[:day].desc, pet_sup_arel[:id].desc).limit(1).includes(:user).includes(:sup).first
  end
  
  def pet_skill(n, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_skill_arel = Result::PetSkill.arel_table
    
    pet_skills.where(:number => n).where(day_arel[:day].lteq(day_i)).
             order(day_arel[:day].desc, pet_skill_arel[:id].desc).limit(1).includes(:user).includes(:skill).first
  end
  
  def statuses(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_status_arel = Result::PetStatus.arel_table
    
    sub_query = pet_statuses.order(day_arel[:day].desc, pet_status_arel[:id].desc).joins(:day).as('statuses')
    Result::PetStatus.select(Arel.star).from(sub_query).group(sub_query[:status_id])
  end
  
  def arts(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_art_arel = Result::PetArt.arel_table
    
    sub_query = pet_arts.order(day_arel[:day].desc, pet_art_arel[:id].desc).joins(:day).as('arts')
    Result::PetArt.select(Arel.star).from(sub_query).group(sub_query[:number])
  end
  
  def sups(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_sup_arel = Result::PetSup.arel_table
    
    sub_query = pet_sups.order(day_arel[:day].desc, pet_sup_arel[:id].desc).joins(:day).as('sups')
    Result::PetSup.select(Arel.star).from(sub_query).group(sub_query[:number])
  end
  
  def skills(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_skill_arel = Result::PetSkill.arel_table
    
    sub_query = pet_skills.order(day_arel[:day].desc, pet_skill_arel[:id].desc).joins(:day).as('skills')
    Result::PetSkill.select(Arel.star).from(sub_query).group(sub_query[:number])
  end
  
  def nickname(day_i = Day.last_day_i)
    profile(day_i).try(:nickname) || plan.name
  end
  
  def status_settings(day_i = Day.last_day_i)
    statuses(day_i).map{|r| {:status=>{:name=>r.status.name,:status_strength=>(r.value + r.bonus)}}}
  end
  
  def art_settings(day_i = Day.last_day_i)
    arts(day_i).map{|r| {:art=>{:kind=>r.art.kind,:name=>r.art.name,:lv=>r.lv}}}
  end
  
  def sup_settings(day_i = Day.last_day_i)
    sups(day_i).map{|r| {:sup=>{:name=>r.sup.name,:lv=>r.lv}}}
  end
  
  def skill_settings(day_i = Day.last_day_i)
    bs = battle_settings(day_i)
    if bs.present?
      bs.map{|r| r.tree}
    else
      plan.tree[:settings].find_all{|h| h[:skill].present? }
    end
  end
  
  def tree(day_i = Day.last_day_i)
    @tree ||= {}
    @tree[day_i] ||= {
      :kind  => kind.name,
      :name  => nickname(day_i),
      :pet   => self,
      :day_i => day_i,
      :settings => status_settings(day_i) +
                   art_settings(day_i) +
                   sup_settings(day_i) +
                   skill_settings(day_i)
    }
  end
end
