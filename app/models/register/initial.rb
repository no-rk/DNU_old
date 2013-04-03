class Register::Initial < ActiveRecord::Base
  belongs_to :user

  has_one  :init_job     , :dependent => :destroy
  has_one  :init_guardian, :dependent => :destroy
  has_many :init_statuses, :order => "status_id ASC", :dependent => :destroy
  has_many :init_arts    , :order => "art_id ASC"   , :dependent => :destroy
  accepts_nested_attributes_for :init_job     , :allow_destroy => true
  accepts_nested_attributes_for :init_guardian, :allow_destroy => true
  accepts_nested_attributes_for :init_statuses, :allow_destroy => true
  accepts_nested_attributes_for :init_arts    , :allow_destroy => true

  attr_accessible :init_job_attributes, :init_guardian_attributes, :init_statuses_attributes, :init_arts_attributes

  after_validation :check_total_value

  after_save :save_result

  def build_initial
    self.build_init_job if self.init_job.nil?
    self.build_init_guardian if self.init_guardian.nil?
  end

  private
  def check_total_value
    total_value = self.init_statuses.inject(0){|sum,init_status| sum + init_status.count}
    errors.add(
      self.init_statuses[0].class.model_name.human + " ",
      I18n.t("status.total", :scope => "register.initials", :total=>Settings.init_status.counter.total.to_s, :now=>total_value.to_s)
    ) if total_value != Settings.init_status.counter.total
  end
  
  def save_result
    # 初期ステータスを結果に反映
    result_status_id = Result::Status.where(:character_type => self.user.class.name).
                                      where(:character_id => self.user.id).pluck(:id)
    self.init_statuses.each do |init_status|
      result_status = Result::Status.where(:id => result_status_id.shift).first_or_initialize
      result_status.character = self.user
      result_status.day = Day.last
      result_status.status = init_status.status
      result_status.count = 0
      result_status.bonus = init_status.count.to_i*5
      result_status.save!
    end
    # 初期技能を結果に反映
    result_art_id = Result::Art.where(:character_type => self.user.class.name).
                                where(:character_id => self.user.id).pluck(:id)
    self.init_arts.each do |init_art|
      result_art = Result::Art.where(:id => result_art_id.shift).first_or_initialize
      result_art.character = self.user
      result_art.day = Day.last
      result_art.art = init_art.art
      result_art.lv     = 5
      result_art.lv_exp = 0
      result_art.lv_cap     = 5
      result_art.lv_cap_exp = 0
      result_art.forget = false
      result_art.save!
    end
    # 守護竜に対応した竜魂を結果に反映
    dragon_souls = GameData::ArtType.where(:name => "竜魂").first.arts
    result_art = Result::Art.where(:id => result_art_id.shift).first_or_initialize
    result_art.character = self.user
    result_art.day = Day.last
    result_art.art = dragon_souls[self.init_guardian.guardian.id.to_i-1]
    result_art.lv     = 5
    result_art.lv_exp = 0
    result_art.forget = false
    result_art.save!
    # 初期生産を結果に反映
    result_product_id = Result::Product.where(:character_type => self.user.class.name).
                                        where(:character_id => self.user.id).pluck(:id)
    GameData::Product.find_each do |product|
      result_product = Result::Product.where(:id => result_product_id.shift).first_or_initialize
      result_product.character = self.user
      result_product.day = Day.last
      result_product.product = product
      result_product.lv     = 1
      result_product.lv_exp = 0
      result_product.forget = false
      result_product.save!
    end
    # 初期職業を結果に反映
    result_job = Result::Job.where(:character_type => self.user.class.name).
                             where(:character_id => self.user.id).first_or_initialize
    result_job.character = self.user
    result_job.day = Day.last
    result_job.job = self.init_job.job
    result_job.lv     = 1
    result_job.lv_exp = 0
    result_job.forget = false
    result_job.save!
    # 初期ポイントを結果に反映
    result_point_id = Result::Point.where(:character_type => self.user.class.name).
                                    where(:character_id => self.user.id).pluck(:id)
    GameData::Point.find_each do |point|
      result_point = Result::Point.where(:id => result_point_id.shift).first_or_initialize
      result_point.character = self.user
      result_point.day = Day.last
      result_point.point = point
      result_point.value = 30
      result_point.save!
    end
    # 習得技を結果に反映
    result_skill_id = Result::Skill.where(:character_type => self.user.class.name).
                                    where(:character_id => self.user.id).pluck(:id)
    GameData::LearningCondition.find_learnable(self.user.result_state, :skill).each do |skill|
      result_skill = Result::Skill.where(:id => result_skill_id.shift).first_or_initialize
      result_skill.character = self.user
      result_skill.day = Day.last
      result_skill.skill = skill
      result_skill.exp = 0
      result_skill.forget = false
      result_skill.save!
    end
  end
end
