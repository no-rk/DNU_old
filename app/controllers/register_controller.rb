class RegisterController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"
  # GET /register
  def index
  end
end
