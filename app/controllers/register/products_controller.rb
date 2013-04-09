class Register::ProductsController < Register::ApplicationController
  private
  def wrap_clone_record(record)
    if record.respond_to?(:day) and record.day.present?
      c_record = Register::Product.new
      c_record.build_product
    else
      c_record = clone_record(record)
    end
    c_record
  end
end
