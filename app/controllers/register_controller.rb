class RegisterController < ApplicationController
  helper_method :communication_message
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"

  # GET /register
  def index
    @title = "ENo.#{current_user.id} 宣言トップ"
  end

  # POST /history
  def history
    history_type = params[:history][:type].to_s
    history_type = "index" if history_type.blank?

    respond_to do |format|
      format.html { redirect_to send("register_#{history_type}_path") } # search.html.erb
      format.json { redirect_to root_path }
    end
  end

  private
  def communication_message
    names = self.class.controller_name
    Communication::Message.new
  end
end
