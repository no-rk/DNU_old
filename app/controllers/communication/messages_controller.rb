class Communication::MessagesController < Communication::ApplicationController
  # PUT /communication/messages/1
  # PUT /communication/messages/1.json
  def update
    if current_user.mark_as_read(current_user.mailbox.notifications(:unread => true).all)
      redirect_to register_index_path, notice: I18n.t("read", :scope => "communication.message")
    else
      redirect_to register_index_path, alert: I18n.t("miss", :scope => "communication.message")
    end
  end
end
