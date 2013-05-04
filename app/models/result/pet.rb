class Result::Pet < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :way,    :polymorphic => true
  belongs_to :plan,   :class_name => "GameData::Character"
  belongs_to :kind,   :class_name => "GameData::CharacterType"
  belongs_to :source, :class_name => "Result::Pet"
  attr_accessible :dispose_protect, :send_protect
  
  has_many :pet_statuses, :dependent => :destroy
  has_many :pet_sups,     :dependent => :destroy
  has_many :pet_skills,   :dependent => :destroy
  
  has_many :pet_inventories
  
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
          pet_status.count  = v[:count]
          pet_status.bonus  = v[:bonus]
          pet_status.source = v[:source] if v[:source].present?
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
  
  def pet_inventory(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    
    pet_inventories.where(day_arel[:day].eq(day_i)).includes(:day).first
  end
  
  def pet_status(status_id, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_status_arel = Result::PetStatus.arel_table
    
    pet_statuses.where(:status_id => status_id).where(day_arel[:day].lteq(day_i)).
                 order(day_arel[:day].desc, pet_status_arel[:id].desc).includes(:day).limit(1).includes(:user).includes(:status).first
  end
  
  def pet_sup(n, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_sup_arel = Result::PetSup.arel_table
    
    pet_sups.where(:number => n).where(day_arel[:day].lteq(day_i)).
             order(day_arel[:day].desc, pet_sup_arel[:id].desc).includes(:day).limit(1).includes(:user).includes(:sup).first
  end
  
  def pet_skill(n, day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_skill_arel = Result::PetSkill.arel_table
    
    pet_skills.where(:number => n).where(day_arel[:day].lteq(day_i)).
             order(day_arel[:day].desc, pet_skill_arel[:id].desc).includes(:day).limit(1).includes(:user).includes(:skill).first
  end
end
