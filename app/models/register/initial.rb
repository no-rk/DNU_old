class Register::Initial < ActiveRecord::Base
  belongs_to :user

  has_one  :init_guardian, :dependent => :destroy
  has_many :init_statuses, :order => "status_id ASC", :dependent => :destroy
  has_many :init_arts    , :order => "art_id ASC"   , :dependent => :destroy
  accepts_nested_attributes_for :init_guardian, :allow_destroy => true
  accepts_nested_attributes_for :init_statuses, :allow_destroy => true
  accepts_nested_attributes_for :init_arts    , :allow_destroy => true

  attr_accessible :init_guardian_attributes, :init_statuses_attributes, :init_arts_attributes

  has_one :guardian, :through => :init_guardian, :class_name => "GameData::Guardian"

  after_validation :check_total_value

  after_save :save_result

  def build_initial
    self.build_init_guardian if self.init_guardian.nil?
    ["職業","武器"].each do |art_type|
      unless self.init_arts.any?{|r| r.type == art_type }
        self.init_arts.build do |init_art|
          init_art.type = art_type
        end
      end
    end
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
      self.user.add_art!({ init_art.type => init_art.name }, 5)
    end
    # 初期技能に対応した装備を結果に反映
    self.user.add_item!({ self.init_arts.find{|v| v.type == "武器" }.name => "初期装備" })
    # テスト用のアイテムを結果に反映
    5.times{ self.user.add_item!("材料"=>"テスト材料") }
    self.user.add_item!("戦物"=>"謎の物質")
    # イベントを結果に反映
    GameData::Event.where(:kind=>["共通", "内部"]).select([:kind, :name]).find_each do |event|
      self.user.add_event!(event.kind => event.name)
    end
    # 守護竜に対応した竜魂を結果に反映
    self.user.add_art!({ self.init_guardian.art.type => self.init_guardian.art.name }, 5)
    # 初期生産を結果に反映
    GameData::Art.find_all_by_type("生産").each do |product|
      self.user.add_art!(product.type => product.name)
    end
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
    result_party.kind = "battle"
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
