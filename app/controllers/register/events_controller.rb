class Register::EventsController < Register::ApplicationController
  def event_content_id
    @event_content_id = params[:event_content_id]
    new
  end
  private
  def register_new_record
    current_user.new_register_events.where(:event_content_id => @event_content_id).first
  end
end
