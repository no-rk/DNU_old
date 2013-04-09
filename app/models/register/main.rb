class Register::Main < ActiveRecord::Base
  belongs_to :user
  belongs_to :day

  has_many :moves,    :order => "id ASC", :dependent => :destroy
  has_many :forgets,  :order => "id ASC", :dependent => :destroy
  has_many :blossoms, :order => "id ASC", :dependent => :destroy
  has_many :trains,   :order => "id ASC", :dependent => :destroy
  has_one  :party_slogan, :dependent => :destroy
  
  accepts_nested_attributes_for :moves,        :allow_destroy => true
  accepts_nested_attributes_for :forgets,      :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :blossoms,     :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :trains,       :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :party_slogan, :allow_destroy => true, :reject_if => :all_blank
  
  attr_accessible :moves_attributes, :forgets_attributes, :blossoms_attributes, :trains_attributes, :party_slogan_attributes
  
  after_validation :check_blossoms
  after_validation :check_forgets
  
  def build_main
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
end
