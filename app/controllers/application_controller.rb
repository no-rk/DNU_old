class ApplicationController < ActionController::Base
  protect_from_forgery

private
  def make_check
    if current_user.makes.count == 0
      redirect_to new_register_make_path, :alert => Settings.make_check.error
      return false
    end
  end
  def make_check!
    unless current_user.makes.count == 0
      redirect_to register_index_path
      return false
    end
  end
end
