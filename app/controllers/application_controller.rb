class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :tx_map
  helper_method :mailbox, :notifications, :conversations
  helper_method :name_by_id, :nickname_by_id, :icons

  private
  def tx_map
    @tx_map ||= Tx::Map.open("#{Rails.root}/db/game_data/dnu")
  end
  def mailbox
    @mailbox ||= current_user.mailbox
  end
  def notifications(options = {})
    mailbox.notifications(options)
  end
  def conversations
    @conversations ||= mailbox.conversations
  end
  def make_check
    if current_user.register_make.nil?
      redirect_to new_register_make_path, :alert => I18n.t("make_check", :scope => "register.message")
      return false
    end
  end
  def nickname_by_id(id)
    begin
      @nickname_by_id ||= Hash.new
      @nickname_by_id[id] ||= User.find(id).nickname
    rescue
      "no id"
    end
  end
  def name_by_id(id)
    begin
      @name_by_id ||= Hash.new
      @name_by_id[id] ||= User.find(id).name
    rescue
      "no id"
    end
  end
  def icons
    begin
      @icons = current_user.icons
    rescue
      @icons = {}
    end
    @icons[1] ||= view_context.image_path("unknown.png")
    @icons
  end
end
