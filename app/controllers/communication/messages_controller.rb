class Communication::MessagesController < Communication::ApplicationController
  # PUT /communication/messages/1
  # PUT /communication/messages/1.json
  def update
    if current_user.mark_as_read(notifications(:unread => true).all)
      redirect_to register_index_path, notice: "kidoku"
    else
      redirect_to register_index_path, alert: "sippai"
    end
  end

  private
  def send_communications(recipients, subject, body)
    recipients = recipients.all if recipients.respond_to?(:all)
    subject = "dengon" if subject.blank?

    recipients.push(current_user) unless recipients.blank?
    Notification.notify_all(recipients, subject, body, current_user)
  end
end
