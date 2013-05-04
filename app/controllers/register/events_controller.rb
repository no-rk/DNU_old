class Register::EventsController < Register::ApplicationController
  private
  def set_instance_variables
    @event_content_id = params[:event_content_id]
  end
  
  def register_index_records
    current_user.register_events.where(:event_content_id => @event_content_id).page(params[:page]).per(Settings.register.history.per)
  end
  
  def register_new_record
    current_user.register_events.where(:event_content_id => @event_content_id).first_or_initialize
  end
end
