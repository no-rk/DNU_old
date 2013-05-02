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
    if params[:history][:url].present?
      redirect_to params[:history][:url]
    else
      redirect_to register_index_path
    end
  end

  private
  def communication_message
    names = self.class.controller_name
    Communication::Message.new
  end
end
