class Result::Pet < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :way,    :polymorphic => true
  belongs_to :plan,   :class_name => "GameData::Character"
  belongs_to :kind,   :class_name => "GameData::CharacterType"
  belongs_to :source, :class_name => "Result::Pet"
  attr_accessible :dispose_protect, :send_protect
  
  has_many :pet_names, :dependent => :destroy
  
  validates :user,            :presence => true
  validates :day,             :presence => true
  validates :kind,            :presence => true
  validates :dispose_protect, :inclusion => { :in => [true, false] }
  validates :send_protect,    :inclusion => { :in => [true, false] }
  
  validate :has_name?
  
  def self.new_pet_by_data(pet_data, user, way = nil, day_i = Day.last_day_i)
    day = Day.find_by_day(day_i)
    result_pet = self.new
    result_pet.kind = GameData::CharacterType.find_by_name(pet_data[:kind].to_s)
    pet_data.each do |k, v|
      if v.present?
        case k.to_sym
        when :name
          result_pet.pet_names.build do |pet_name|
            pet_name.user    = user
            pet_name.day     = day
            pet_name.way     = way
            pet_name.name    = pet_data[:name].to_s
            pet_name.caption = pet_data[:caption].to_s if pet_data[:caption].present?
            pet_name.source  = pet_data[:source] if pet_data[:source].present?
          end
        end
      end
    end
    result_pet
  end
  
  def self.new_pet_by_kind_and_name(pet_kind, pet_name, user, way = nil, day_i = Day.last_day_i)
    pet_plan = GameData::Character.where(:kind => pet_kind, :name => pet_name).first
    
    if pet_plan.present?
      pet_data = pet_plan.tree
      
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
  
  def pet_name(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    pet_name_arel = Result::PetName.arel_table
    
    pet_names.where(day_arel[:day].lteq(day_i)).order(day_arel[:day].desc, pet_name_arel[:id].desc).includes(:day).limit(1).includes(:user).first
  end
  
  private
  def has_name?
    if self.pet_names.blank?
      errors.add(:pet_names, :invalid)
    end
  end
end
