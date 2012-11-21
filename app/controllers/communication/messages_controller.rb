class Communication::MessagesController < Communication::ApplicationController
  # PUT /communication/messages/1
  # PUT /communication/messages/1.json
  def update
    if current_user.mark_as_read(current_user.mailbox.notifications(:unread => true).all)
      redirect_to register_index_path, notice: "kidoku"
    else
      redirect_to register_index_path, alert: "sippai"
    end
  end

  private
  def send_communications(recipients, subject, body)
    recipients = recipients.all if recipients.respond_to?(:all)
    #件名が空欄ならデフォルト
    subject = "dengon" if subject.blank?
    #自分にも送る
    recipients.push(current_user) unless recipients.blank?
    receipts = Notification.notify_all(recipients, subject, body, current_user)
    #自分宛は既読にする。
    current_user.mark_as_read(current_user.mailbox.notifications(:unread => true).find_by_notified_object_id(current_user.id))
    receipts
  end
end
