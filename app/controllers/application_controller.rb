class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :mailbox, :notifications, :conversations

  private
  def mailbox
    @mailbox ||= current_user.mailbox
  end
  def notifications
    @notifications ||= mailbox.notifications
  end
  def conversations
    @conversations ||= mailbox.conversations
  end
  def make_check
    if current_user.makes.count == 0
      redirect_to new_register_make_path, :alert => I18n.t("make_check", :scope => "register.message")
      return false
    end
  end
end
