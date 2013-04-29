class Register::Main < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_one  :diary,    :dependent => :destroy
  has_many :shouts,   :order => "id ASC", :dependent => :destroy
  has_many :disposes, :order => "id ASC", :dependent => :destroy
  has_many :moves,    :order => "id ASC", :dependent => :destroy
  has_many :forgets,  :order => "id ASC", :dependent => :destroy
  has_many :blossoms, :order => "id ASC", :dependent => :destroy
  has_many :trains,   :order => "id ASC", :dependent => :destroy
  has_one  :party_slogan, :dependent => :destroy
  
  accepts_nested_attributes_for :diary,        :reject_if => :all_blank
  accepts_nested_attributes_for :shouts,       :reject_if => :no_change_from_default
  accepts_nested_attributes_for :disposes,     :reject_if => :all_blank
  accepts_nested_attributes_for :moves
  accepts_nested_attributes_for :forgets,      :reject_if => :all_blank
  accepts_nested_attributes_for :blossoms,     :reject_if => :all_blank
  accepts_nested_attributes_for :trains,       :reject_if => :all_blank
  accepts_nested_attributes_for :party_slogan, :reject_if => :all_blank
  
  attr_accessible :diary_attributes, :shouts_attributes, :disposes_attributes, :moves_attributes, :forgets_attributes, :blossoms_attributes, :trains_attributes, :party_slogan_attributes
  
  after_validation :check_blossoms
  after_validation :check_forgets
  
  def build_main
    self.build_diary if self.diary.nil?
    (1-self.shouts.size).times{self.shouts.build}
    (5-self.disposes.size).times{self.disposes.build}
    (5-self.moves.size).times{self.moves.build}
    (3-self.forgets.size).times{self.forgets.build}
    (3-self.blossoms.size).times{self.blossoms.build}
    (8-self.trains.size).times{self.trains.build}
    self.build_party_slogan if self.party_slogan.nil?
  end
  
  private
  def check_blossoms
    ids = self.blossoms.map{|r| r.train_id }.compact
    if ids.count != ids.uniq.count
      errors.add(
        self.blossoms[0].class.model_name.human + " ",
        I18n.t("blossoms", :scope => "register.main")
      )
    end
  end
  def check_forgets
    ids = self.forgets.map{|r| r.train_id }.compact
    if ids.count != ids.uniq.count
      errors.add(
        self.forgets[0].class.model_name.human + " ",
        I18n.t("forgets", :scope => "register.main")
      )
    end
  end
  def no_change_from_default(row)
    # volume以外が全てブランクの場合リジェクト
    row.all?{ |k,v| [:volume].include?(k.to_sym) ? true : v.blank? }
  end
end
