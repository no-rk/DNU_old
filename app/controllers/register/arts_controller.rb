class Register::ArtsController < Register::ApplicationController
  def index
    @art_id = params[:art_id]
    super
  end
  
  def new
    @art_id = params[:art_id]
    super
  end
  
  private
  def register_index_records
    current_user.register_arts.where(:art_id => @art_id).page(params[:page]).per(Settings.register.history.per)
  end
  
  def register_new_record
    current_user.register_arts.where(:art_id => @art_id).first_or_initialize
  end
end
