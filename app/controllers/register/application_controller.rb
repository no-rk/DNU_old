class Register::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"

  # GET /register/controller_name
  # GET /register/controller_name.json
  def index
    names = self.class.controller_name

    registers = eval "current_user.#{names}.scoped.page(params[:page]).per(Settings.register.history.per)"

    self.instance_variable_set("@register_#{names}",registers)
    @read_only = true
    @update_time = true

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: registers }
    end
  end

  # GET /register/controller_name/1
  # GET /register/controller_name/1.json
  def show
    names = self.class.controller_name
    name  = names.singularize

    register = eval "current_user.#{names}.find(params[:id])"

    self.instance_variable_set("@register_#{name}",register)
    @read_only = true

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

    temp = eval "current_user.#{name}"
    register = eval "temp.nil? ? Register::#{names.classify}.new : clone_record(temp)"
    eval "register.build_#{name}"

    self.instance_variable_set("@register_#{name}",register)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: register }
    end
  end

  # GET /register/controller_name/1/edit
  def edit
    names = self.class.controller_name
    name  = names.singularize

    register = eval "current_user.#{names}.find(params[:id])"
    eval "register.build_#{name}"

    self.instance_variable_set("@register_#{name}",register)
  end

  # POST /register/controller_name
  # POST /register/controller_name.json
  def create
    names = self.class.controller_name
    name  = names.singularize

    register = eval "Register::#{names.classify}.new(params[:register_#{name}])"
    register.user = current_user

    self.instance_variable_set("@register_#{name}",register)
    @read_only = true if request.xhr?

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          #成功しなかった場合は例外発生
          register.save!
          #Ajaxの場合は例外発生させて保存しない
          rise if request.xhr?
        end
        format.html { redirect_to register, notice: I18n.t("create", :scope => "register.#{names}") }
        format.json { render json: register, status: :created, location: register }
      rescue
        format.html { render :partial => 'form', :locals=>{eval(":register_#{name}")=>register} } if @read_only
        format.html { render action: "new" }
        format.json { render json: { "change" => changed?(register), "errors" => register.errors.full_messages } } if @read_only
        format.json { render json: register.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /register/controller_name/1
  # PUT /register/controller_name/1.json
  def update
    names = self.class.controller_name
    name  = names.singularize

    register = eval "Register::#{names.classify}.find(params[:id])"
    register.touch

    self.instance_variable_set("@register_#{name}",register)
    @read_only = true if request.xhr?

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          #成功しなかった場合は例外発生
          register.update_attributes!(params["register_#{name}"])
          #Ajaxの場合は例外発生させて保存しない
          rise if request.xhr?
        end
        format.html { redirect_to register, notice: I18n.t("update", :scope => "register.#{names}") }
        format.json { head :no_content }
      rescue
        format.html { render :partial => 'form', :locals=>{eval(":register_#{name}")=>register} } if @read_only
        format.html { render action: "edit" }
        format.json { render json: { "change" => changed?(register), "errors" => register.errors.full_messages } } if @read_only
        format.json { render json: register.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register/controller_name/1
  # DELETE /register/controller_name/1.json
  def destroy
    names = self.class.controller_name
    name  = names.singularize

    register = eval "current_user.#{names}.find(params[:id])"
    register.destroy

    self.instance_variable_set("@register_#{name}",register)

    respond_to do |format|
      format.html { redirect_to eval("register_#{names}_url") }
      format.json { head :no_content }
    end
  end

  private
  def clone_record(record)
    nested_attr = record.nested_attributes_options.map{|key,value| key}
    return record.dup(:include=>nested_attr)
  end
  def changed?(record)
    last_record = eval "current_user.#{record.class.model_name.split('::').last.downcase}"

    if last_record.nil?
      return false
    end

    nested_attr = record.nested_attributes_options.map{|key,value| key}
    return true if clone_record(record).to_json(:include=>nested_attr) != clone_record(last_record).to_json(:include=>nested_attr)
    false
  end
end
