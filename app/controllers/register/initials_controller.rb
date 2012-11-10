class Register::InitialsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"
  # GET /register/initials
  # GET /register/initials.json
  def index
    @register_initials = current_user.initials

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @register_initials }
    end
  end

  # GET /register/initials/1
  # GET /register/initials/1.json
  def show
    @register_initial = current_user.initials.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @register_initial }
    end
  end

  # GET /register/initials/new
  # GET /register/initials/new.json
  def new
    @temp_initial = current_user.initials.find(:last)
    if @temp_initial.nil?
      @register_initial = Register::Initial.new 
      @register_initial.build_init_job
    else
      @register_initial = clone_record(@temp_initial)
      @register_initial.build_init_job if @register_initial.init_job.nil?
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @register_initial }
    end
  end

  # GET /register/initials/1/edit
  def edit
    @register_initial = current_user.initials.find(params[:id])
  end

  # POST /register/initials
  # POST /register/initials.json
  def create
    @register_initial = Register::Initial.new(params[:register_initial])
    @register_initial.user = current_user

    @read_only = true if request.xhr?

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          #成功しなかった場合は例外発生
          @register_initial.save!
          #Ajaxの場合は例外発生させて保存しない
          rise if request.xhr?
        end
        format.html { redirect_to @register_initial, notice: I18n.t("create", :scope => "register.initials") }
        format.json { render json: @register_initial, status: :created, location: @register_initial }
      rescue
        format.html { render :partial => 'form' } if @read_only
        format.html { render action: "new" }
        format.json { render json: { "change" => changed?(@register_initial), "error" => @register_initial.errors.count } } if @read_only
        format.json { render json: @register_initial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /register/initials/1
  # PUT /register/initials/1.json
  def update
    @register_initial = Register::Initial.find(params[:id])

    respond_to do |format|
      if @register_initial.update_attributes(params[:register_initial])
        format.html { redirect_to @register_initial, notice: 'initial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @register_initial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register/initials/1
  # DELETE /register/initials/1.json
  def destroy
    @register_initial = current_user.initials.find(params[:id])
    @register_initial.destroy

    respond_to do |format|
      format.html { redirect_to register_initials_url }
      format.json { head :no_content }
    end
  end
end
