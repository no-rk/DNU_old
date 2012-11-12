class RegisterController < Register::ApplicationController
  # GET /register
  def index
  end

  # POST /history
  def history
    respond_to do |format|
      format.html { redirect_to eval("register_#{params[:history][:type]}_path") } # search.html.erb
      format.json { redirect_to root_path }
    end
  end
end
