class Register::MakesController < ApplicationController
  before_filter :authenticate_user!
  layout "register"
  # GET /register/makes
  # GET /register/makes.json
  def index
    @register_makes = current_user.makes

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @register_makes }
    end
  end

  # GET /register/makes/1
  # GET /register/makes/1.json
  def show
    @register_make = current_user.makes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @register_make }
    end
  end

  # GET /register/makes/new
  # GET /register/makes/new.json
  def new
    @register_make = Register::Make.new
    @register_make.build_profile

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @register_make }
    end
  end

  # GET /register/makes/1/edit
  def edit
    @register_make = current_user.makes.find(params[:id])
    @register_make.build_profile if @register_make.profile.nil?
  end

  # POST /register/makes
  # POST /register/makes.json
  def create
    @register_make = Register::Make.new(params[:register_make])
    @register_make.build_profile if @register_make.profile.nil?
    @register_make.user = current_user

    respond_to do |format|
      if @register_make.save
        format.html { redirect_to @register_make, notice: 'Make was successfully created.' }
        format.json { render json: @register_make, status: :created, location: @register_make }
      else
        format.html { render action: "new" }
        format.json { render json: @register_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /register/makes/1
  # PUT /register/makes/1.json
  def update
    @register_make = Register::Make.find(params[:id])
    @register_make.build_profile if @register_make.profile.nil?

    respond_to do |format|
      if @register_make.update_attributes(params[:register_make])
        format.html { redirect_to @register_make, notice: 'Make was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @register_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register/makes/1
  # DELETE /register/makes/1.json
  def destroy
    @register_make = current_user.makes.find(params[:id])
    @register_make.destroy

    respond_to do |format|
      format.html { redirect_to register_makes_url }
      format.json { head :no_content }
    end
  end
end
