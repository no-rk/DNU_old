class Register::TradesController < Register::ApplicationController
  private
  def wrap_clone_record(record)
    if record.respond_to?(:day) and record.day.present?
      names = self.class.controller_name
      c_record = "Register::#{names.classify}".constantize.new
    else
      c_record = clone_record(record)
    end
    c_record
  end
end
