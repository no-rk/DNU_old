class Communication::ApplicationController < ApplicationController
  helper_method :communication
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"

  # GET /communication/controller_name
  # GET /communication/controller_name.json
  def index
  end

  # GET /communication/controller_name/1
  # GET /communication/controller_name/1.json
  def show
  end

  # GET /communication/controller_name/new
  # GET /communication/controller_name/new.json
  def new
  end

  # GET /communication/controller_name/1/edit
  def edit
  end

  # POST /communication/controller_name
  # POST /communication/controller_name.json
  def create
    names = self.class.controller_name
    name  = names.singularize

    communication.user = current_user

    if communication.save
      redirect_to register_index_path, notice: I18n.t("success", :scope => "communication.#{name}")
    else
      flash[:alert] = communication.flash_alert
      render action: "new"
    end
  end

  # PUT /communication/controller_name/1
  # PUT /communication/controller_name/1.json
  def update
  end

  # DELETE /communication/controller_name/1
  # DELETE /communication/controller_name/1.json
  def destroy
  end

  private
  def communication
    names = self.class.controller_name
    name  = names.singularize

    @communication ||= "Communication::#{names.classify}".constantize.new(params[:"communication_#{name}"])
  end
end
