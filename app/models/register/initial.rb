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

  has_one :guardian, :through => :init_guardian, :class_name => "GameData::Guardian"

  after_validation :check_total_value

  after_save :save_result

  def build_initial
    self.build_init_job if self.init_job.nil?
    self.build_init_guardian if self.init_guardian.nil?
    (1-self.init_arts.size).times{self.init_arts.build}
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
    # 削除
    self.user.result(:inventory).each{ |r| r.item.destroy }
    self.user.result(:passed_day).destroy_all
    # 経過日数を結果に反映
    self.user.create_result!(:passed_day, { :passed_day => 0 })
    # 初期ステータスを結果に反映
    self.init_statuses.each do |init_status|
      self.user.create_result!(:status, {
        :status => init_status.status,
        :count  => 0,
        :bonus  => init_status.count.to_i*5
      })
    end
    # 初期技能を結果に反映
    self.init_arts.each do |init_art|
      self.user.create_result!(:art, {
        :art        => init_art.art,
        :lv         => 5,
        :lv_exp     => 0,
        :lv_cap     => 5,
        :lv_cap_exp => 0,
        :forget     => false
      })
    end
    # 初期技能に対応した装備を結果に反映
    self.user.add_item!({
      self.init_arts.first.art.name => "初期装備"
    },
      GameData::Product.find_by_name("鍛治")
    )
    # 守護竜に対応した竜魂を結果に反映
    dragon_souls = GameData::ArtType.where(:name => "竜魂").first.arts
    self.user.create_result!(:art, {
      :art    => dragon_souls[self.init_guardian.guardian.id.to_i-1],
      :lv     => 5,
      :lv_exp => 0,
      :forget => false
    })
    # 初期生産を結果に反映
    GameData::Product.find_each do |product|
      self.user.create_result!(:product, {
        :product => product,
        :lv      => 1,
        :lv_exp  => 0,
        :forget  => false
      })
    end
    # 初期職業を結果に反映
    self.user.create_result!(:job, {
      :job    => self.init_job.job,
      :lv     => 1,
      :lv_exp => 0,
      :forget => false
    })
    # 初期ポイントを結果に反映
    GameData::Point.find_each do |point|
      self.user.create_result!(:point, {
        :point => point,
        :value => 500
      })
    end
    # 習得技を結果に反映
    GameData::LearningCondition.find_learnable(self.user.result_state, :skill).each do |skill|
      self.user.create_result!(:skill, {
        :skill  => skill,
        :exp    => 0,
        :forget => false
      })
    end
    # 現在地を結果に反映
    self.user.create_result!(:place, {
      :map_tip => GameData::Map.find_by_name("MAP1").map_tips.where(:x => 4, :y => 24).first,
      :arrival => true
    })
    # PTを結果に反映
    result_party_id = Result::PartyMember.where(:character_type => self.user.class.name).
                                          where(:character_id => self.user.id).pluck(:party_id)
    result_party = Result::Party.where(:id => result_party_id.shift).first_or_initialize
    result_party.day = Day.last
    result_party.kind = :battle
    result_party.party_members.build if result_party.party_members.blank?
    result_party.party_members.first.character = self.user
    result_party.save!
    # マップ生成
    map = self.user.result(:place).first.map
    if Result::Map.where(:map_id => map.id).all.blank?
      result_map = Result::Map.new
      result_map.day = Day.last
      result_map.map = map
      result_map.image = DNU::GenerateMap.apply(map)
      result_map.save!
    end
  end
end
