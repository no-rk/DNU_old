class Register::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check
  before_filter :set_title
  layout "register"

  # GET /register/controller_name
  # GET /register/controller_name.json
  def index
    @read_only = true
    names = self.class.controller_name
    set_instance_variables

    registers = current_user.send("register_#{names}").page(params[:page]).per(Settings.register.history.per)

    self.instance_variable_set("@register_#{names}",registers)
    @update_time = true

    if registers.blank?
      respond_to do |format|
        format.html { redirect_to register_index_path, alert: I18n.t("index", :scope => "register.message", :model_name => "Register::#{names.classify}".constantize.model_name.human) }
        format.json { render json: registers }
      end
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: registers }
      end
    end
  end

  # GET /register/controller_name/1
  # GET /register/controller_name/1.json
  def show
    @read_only = true
    names = self.class.controller_name
    name  = names.singularize
    set_instance_variables

    register = current_user.send("register_#{names}").find(params[:id])

    self.instance_variable_set("@register_#{name}",register)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: register }
    end
  end

  # GET /register/controller_name/new
  # GET /register/controller_name/new.json
  def new
    names = self.class.controller_name
    name  = names.singularize
    set_instance_variables

    register = current_user.send("register_#{name}") || "Register::#{names.classify}".constantize.new
    register.send("build_#{name}")
    build_record(register)

    self.instance_variable_set("@register_#{name}", register.new_record? ? register : wrap_clone_record(register))

    respond_to do |format|
      format.html { render action: "new" }
      format.json { render json: register }
    end
  end

  # GET /register/controller_name/1/edit
  def edit
    names = self.class.controller_name
    name  = names.singularize
    set_instance_variables

    register = current_user.send("register_#{names}").find(params[:id])
    register.send("build_#{name}")
    build_record(register)

    self.instance_variable_set("@register_#{name}",register)
  end

  # POST /register/controller_name
  # POST /register/controller_name.json
  def create
    @read_only = true if request.xhr?
    names = self.class.controller_name
    name  = names.singularize
    set_instance_variables

    register = "Register::#{names.classify}".constantize.new(params[:"register_#{name}"])
    # register.send("build_#{name}")
    # build_record(register)
    register.user = current_user

    self.instance_variable_set("@register_#{name}",register)

    respond_to do |format|
      #Ajaxの場合はバリデートのみ行う
      if @read_only
        register.valid?
        format.html { render :partial => 'form', :locals => { :"register_#{name}" => register } }
        format.json { render json: { "errors" => register.errors.full_messages } }
      else
        if register.save
          save_success(register)
          format.html { redirect_to register, notice: I18n.t("create", :scope => "register.message", :model_name => "Register::#{names.classify}".constantize.model_name.human) }
          format.json { render json: register, status: :created, location: register }
        else
          format.html { render action: "new" }
          format.json { render json: register.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /register/controller_name/1
  # PUT /register/controller_name/1.json
  def update
    @read_only = true if request.xhr?
    names = self.class.controller_name
    name  = names.singularize
    set_instance_variables

    register = "Register::#{names.classify}".constantize.find(params[:id])
    register.assign_attributes(params[:"register_#{name}"])
    # register.send("build_#{name}")
    # build_record(register)
    if register.respond_to?(:day) and register.day.present?
      register = clone_record(register)
      register.day = nil
    else
      register.touch
    end

    self.instance_variable_set("@register_#{name}",register)

    respond_to do |format|
      #Ajaxの場合はバリデートのみ行う
      if @read_only
        register.valid?
        format.html { render :partial => 'form', :locals => { :"register_#{name}" => register } }
        format.json { render json: { "errors" => register.errors.full_messages } }
      else
        if register.save
          save_success(register)
          format.html { redirect_to register, notice: I18n.t("update", :scope => "register.message", :model_name => "Register::#{names.classify}".constantize.model_name.human) }
          format.json { head :no_content }
        else
          format.html { render action: edit_action }
          format.json { render json: register.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /register/controller_name/1
  # DELETE /register/controller_name/1.json
  def destroy
    names = self.class.controller_name
    name  = names.singularize
    set_instance_variables

    register = current_user.send("register_#{names}").find(params[:id])
    register.destroy

    self.instance_variable_set("@register_#{name}",register)

    respond_to do |format|
      format.html { redirect_to send("register_#{names}_url") }
      format.json { head :no_content }
    end
  end

  private
  def set_title
    @title = "ENo.#{current_user.id} " + "Register::#{controller_name.classify}".constantize.model_name.human
  end
  def wrap_clone_record(record)
    clone_record(record)
  end
  def clone_record(record)
    DNU::DeepClone.register(record)
  end
  def edit_action
    "edit"
  end
  def save_success(register)
  end
  def set_instance_variables
  end
  def build_record(record)
  end
end
