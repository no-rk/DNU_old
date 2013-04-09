class Register::TradesController < Register::ApplicationController
  private
  def wrap_clone_record(record)
    if record.respond_to?(:day) and record.day.present?
      c_record = Register::Trade.new
      c_record.build_trade
    else
      c_record = clone_record(record)
    end
    c_record
  end
end
