class Register::EventsController < Register::ApplicationController
  def index
    @event_content_id = params[:event_content_id]
    super
  end
  
  def new
    @event_content_id = params[:event_content_id]
    super
  end
  
  private
  def register_index_records
    current_user.register_events.where(:event_content_id => @event_content_id).page(params[:page]).per(Settings.register.history.per)
  end
  
  def register_new_record
    current_user.new_register_events.where(:event_content_id => @event_content_id).first
  end
end
