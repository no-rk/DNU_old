class Register::Initial < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

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
end
