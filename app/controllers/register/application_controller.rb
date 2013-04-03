class Register::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"

  # GET /register/controller_name
  # GET /register/controller_name.json
  def index
    names = self.class.controller_name

    registers = current_user.try(names).scoped.page(params[:page]).per(Settings.register.history.per)

    self.instance_variable_set("@register_#{names}",registers)
    @read_only = true
    @update_time = true
    set_instance_variables

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
    names = self.class.controller_name
    name  = names.singularize

    register = current_user.try(names).find(params[:id])

    self.instance_variable_set("@register_#{name}",register)
    @read_only = true
    set_instance_variables

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

    temp = current_user.try(name)
    register = temp.nil? ? "Register::#{names.classify}".constantize.new : wrap_clone_record(temp)
    register.try("build_#{name}")

    self.instance_variable_set("@register_#{name}",register)
    set_instance_variables

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: register }
    end
  end

  # GET /register/controller_name/1/edit
  def edit
    names = self.class.controller_name
    name  = names.singularize

    register = current_user.try(names).find(params[:id])
    register.try("build_#{name}")

    self.instance_variable_set("@register_#{name}",register)
    set_instance_variables
  end

  # POST /register/controller_name
  # POST /register/controller_name.json
  def create
    names = self.class.controller_name
    name  = names.singularize

    register = "Register::#{names.classify}".constantize.new(params[:"register_#{name}"])
    register.user = current_user

    self.instance_variable_set("@register_#{name}",register)
    @read_only = true if request.xhr?
    set_instance_variables

    respond_to do |format|
      #Ajaxの場合はバリデートのみ行う
      if @read_only
        register.valid?
        format.html { render :partial => 'form', :locals => { :"register_#{name}" => register } }
        format.json { render json: { "change" => changed?(register), "errors" => register.errors.full_messages } }
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
    names = self.class.controller_name
    name  = names.singularize

    register = "Register::#{names.classify}".constantize.find(params[:id])
    register.assign_attributes(params[:"register_#{name}"])
    if register.respond_to?(:day) and register.day.present?
      register = clone_record(register)
      register.day = nil
    else
      register.touch
    end

    self.instance_variable_set("@register_#{name}",register)
    @read_only = true if request.xhr?
    set_instance_variables

    respond_to do |format|
      #Ajaxの場合はバリデートのみ行う
      if @read_only
        register.valid?
        format.html { render :partial => 'form', :locals => { :"register_#{name}" => register } }
        format.json { render json: { "change" => changed?(register), "errors" => register.errors.full_messages } }
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

    register = current_user.try(names).find(params[:id])
    register.destroy

    self.instance_variable_set("@register_#{name}",register)
    set_instance_variables

    respond_to do |format|
      format.html { redirect_to send("register_#{names}_url") }
      format.json { head :no_content }
    end
  end

  private
  def wrap_clone_record(record)
    clone_record(record)
  end
  def clone_record(record)
    DNU::DeepClone.register(record)
  end
  def changed?(record)
    last_record = current_user.try(record.class.model_name.split('::').last.downcase)

    if last_record.nil?
      return false
    end

    nested_attr = record.nested_attributes_options.map{|key,value| key}
    return true if clone_record(record).to_json(:include=>nested_attr) != clone_record(last_record).to_json(:include=>nested_attr)
    false
  end
  def edit_action
    "edit"
  end
  def save_success(register)
  end
  def set_instance_variables
  end
end
