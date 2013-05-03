class Register::ProductsController < Register::ApplicationController
  private
  def register_new_record
    current_user.send("register_#{names}").where(:day_id => nil).first_or_initialize
  end
end
