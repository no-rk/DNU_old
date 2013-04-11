class Register::MakesController < Register::ApplicationController
  # GET /register/makes/new
  # GET /register/makes/new.json
  def new
    set_instance_variables
    
    @register_make = Register::Make.new
    
    @register_character = Register::Character.new
    @register_character.build_character
    
    @register_initial = Register::Initial.new
    @register_initial.build_initial
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @register_make }
    end
  end

  # POST /register/makes
  # POST /register/makes.json
  def create
    @read_only = true if request.xhr?
    set_instance_variables
    
    @register_make = Register::Make.new(params[:register_make])
    @register_make.user = current_user
    
    #characterテーブルに保存する
    @register_character = Register::Character.new(params[:register_character])
    @register_character.user = current_user
    
    #initialテーブルに保存する
    @register_initial = Register::Initial.new(params[:register_initial])
    @register_initial.user = current_user
    
    respond_to do |format|
      #Ajaxの場合はバリデートのみ行う
      if @read_only
        @register_make.valid?
        @register_character.valid?
        @register_initial.valid?
        format.html { render :partial => 'form', :locals=>{:register_make=>@register_make,:register_character=>@register_character,:register_initial=>@register_initial} }
        format.json { render json: {
          "change" => changed?(@register_make) || changed?(@register_character) || changed?(@register_initial),
          "errors" => @register_make.errors.full_messages + @register_character.errors.full_messages + @register_initial.errors.full_messages
        } }
      else
        if @register_make.valid? & @register_character.valid? & @register_initial.valid?
          begin
            ActiveRecord::Base.transaction do
              #全て成功しなかった場合は例外発生
              raise unless @register_make.save & @register_character.save & @register_initial.save
              # キャラ作成した日付を保存
              current_user.creation_day = Day.last_day_i
              raise unless current_user.save
            end
            format.html { redirect_to register_index_path, notice: I18n.t("create", :scope => "register.message", :model_name => Register::Character.model_name.human) }
            format.json { render json: @register_make, status: :created, location: @register_make }
          rescue
            format.html { render action: "new", alert: I18n.t("error", :scope => "register.message", :model_name => Register::Character.model_name.human) }
            format.json { render json: @register_make.errors, status: :unprocessable_entity }
          end
        else
          format.html { render action: "new" }
          format.json { render json: @register_make.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
  def make_check
    if current_user.make.present?
      redirect_to register_index_path
      return false
    end
  end
  def set_instance_variables
    @jobs      ||= GameData::Job.all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
    @guardians ||= GameData::Guardian.all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
    @statuses  ||= GameData::Status.all.map{|t| {:id => t.id, :name => t.name} }
    @arts      ||= GameData::Art.where(GameData::ArtType.arel_table[:name].eq("武器")).includes(:art_type).all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
  end
end
