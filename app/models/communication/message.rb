class Communication::Message < ActiveForm
  extend ActiveModel::Callbacks
  define_model_callbacks :validation
  
  validates :recipients, :presence => true
  validates :subject   , :length => { :maximum => Settings.maximum.subject, :tokenizer => DNU::Text.counter(:string) }
  validates :body      , :presence => true, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  attr_accessor :recipients, :subject, :body, :user, :flash_alert
  
  def column_for_attribute(attribute_name)
    Notification.new.column_for_attribute(attribute_name)
  end
  
  def day
    nil
  end
  
  def save
    _run_validation_callbacks do
      return false unless self.valid?
    end
    recipients = User.where( :id => self.recipients.split(',') )
    if recipients.count == 0
      #送信相手居なかったらエラー
      errors.add(:recipients,I18n.t("nonexistent", :scope => "communication.message"))
      return false
    end
    receipts = send_communications(recipients, self.subject, self.body, self.user)
    unless Notification.successful_delivery?(receipts)
      #送信失敗したらアラート
      self.flash_alert = I18n.t("failure", :scope => "communication.message")
      return false 
    end
    true
  end
  
  private
  def send_communications(recipients, subject, body, user)
    recipients = recipients.all if recipients.respond_to?(:all)
    #件名が空欄ならデフォルト
    subject = I18n.t("subject", :scope => "communication.message") if subject.blank?
    #自分にも送る
    recipients.push(user) unless recipients.blank?
    receipts = Notification.notify_all(recipients, subject, body, user, false)
    #自分宛は既読にする。
    user.mark_as_read(user.mailbox.notifications(:unread => true).find_by_notified_object_id(user.id))
    receipts
  end
end
