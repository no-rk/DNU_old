class Register::Initial < ActiveRecord::Base
  belongs_to :user, :class_name => "User"

  has_one :init_job, :dependent => :destroy
  accepts_nested_attributes_for :init_job, :allow_destroy => true
  has_many :init_statuses, :dependent => :destroy
  accepts_nested_attributes_for :init_statuses, :allow_destroy => true

  attr_accessible :init_job_attributes, :init_statuses_attributes

  after_validation :check_total_value

  private
  def check_total_value
    total_value = self.init_statuses.inject(0){|sum,init_status| sum + init_status.count}
    errors.add(
      self.init_statuses[0].class.model_name.human + " ",
      I18n.t("status.total", :scope => "register.initials", :total=>Settings.init_status.count.total.to_s, :now=>total_value.to_s)
    ) if total_value != Settings.init_status.count.total
  end
end
