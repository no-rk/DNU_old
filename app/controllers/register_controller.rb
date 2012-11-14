class RegisterController < Register::ApplicationController
  # GET /register
  def index
  end

  # POST /history
  def history
    history_type = params[:history][:type].to_s
    history_type = "index" if history_type.blank?

    respond_to do |format|
      format.html { redirect_to eval("register_#{history_type}_path") } # search.html.erb
      format.json { redirect_to root_path }
    end
  end
end
