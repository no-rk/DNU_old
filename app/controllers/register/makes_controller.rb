class Register::MakesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :make_check!
  layout "register"
  # GET /register/makes/new
  # GET /register/makes/new.json
  def new
    @register_make    = Register::Make.new
    @register_character = Register::Character.new
    @register_character.build_profile
    @register_initial = Register::Initial.new
    @register_initial.build_init_job

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @register_make }
    end
  end

  # POST /register/makes
  # POST /register/makes.json
  def create
    @register_make = Register::Make.new(params[:register_make])
    @register_make.user = current_user

    #characterテーブルにprofile保存する
    @register_character = Register::Character.new
    @register_character.profile = Register::Profile.new(params[:register_profile])
    @register_character.user    = current_user

    #initialテーブルにinit_job保存する
    @register_initial = Register::Initial.new
    @register_initial.init_job = Register::InitJob.new(params[:register_init_job])
    @register_initial.user    = current_user

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          #全て成功しなかった場合は例外発生
          unless @register_make.save & @register_character.save & @register_initial.save
            rise
          end
        end
        format.html { redirect_to register_index_path, notice: Settings.makes.create }
        format.json { render json: @register_make, status: :created, location: @register_make }
      rescue
        format.html { render action: "new" }
        format.json { render json: @register_make.errors, status: :unprocessable_entity }
      end
    end
  end
end
