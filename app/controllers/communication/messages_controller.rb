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
end
