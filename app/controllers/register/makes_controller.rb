class Register::MakesController < Register::ApplicationController
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

    #characterテーブルに保存する
    @register_character = Register::Character.new(params[:register_character])
    @register_character.user    = current_user

    #initialテーブルに保存する
    @register_initial = Register::Initial.new(params[:register_initial])
    @register_initial.user    = current_user

    @read_only = true if request.xhr?

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          #全て成功しなかった場合は例外発生
          rise unless @register_make.save & @register_character.save & @register_initial.save
          #Ajaxの場合は例外発生させて保存しない
          rise if request.xhr?
        end
        format.html { redirect_to register_index_path, notice: I18n.t("create", :scope => "register.makes") }
        format.json { render json: @register_make, status: :created, location: @register_make }
      rescue
        format.html { render :partial => 'form', :locals=>{:register_make=>@register_make,:register_character=>@register_character,:register_initial=>@register_initial} } if @read_only
        format.html { render action: "new" }
        format.json { render json: {
          "change" => changed?(@register_make) || changed?(@register_character) || changed?(@register_initial),
          "errors" => @register_make.errors.full_messages + @register_character.errors.full_messages + @register_initial.errors.full_messages
        } } if @read_only
        format.json { render json: @register_make.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def make_check
    unless current_user.makes.count == 0
      redirect_to register_index_path
      return false
    end
  end
end
