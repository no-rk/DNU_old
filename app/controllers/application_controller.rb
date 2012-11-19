class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :name_by_id, :nickname_by_id
  helper_method :mailbox, :notifications, :conversations

  private
  def mailbox
    @mailbox ||= current_user.mailbox
  end
  def notifications(options = {})
    @notifications ||= mailbox.notifications(options)
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
  def nickname_by_id(id)
    begin
      @nickname_by_id ||= Hash.new
      @nickname_by_id[id] ||= User.find(id).character.profile.nickname
    rescue
      "no id"
    end
  end
  def name_by_id(id)
    begin
      @name_by_id ||= Hash.new
      @name_by_id[id] ||= User.find(id).character.profile.name
    rescue
      "no id"
    end
  end
end
