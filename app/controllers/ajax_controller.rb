class AjaxController < ApplicationController
  # GET /ajax_img/:model(/:id)
  # GET /ajax_img/:model(/:id).json
  def img
    begin
      if params[:id]
        @ajax = "Register::#{params[:model].classify}".constantize.find(params[:id])
      else
        @ajax = "Register::#{params[:model].classify}".constantize.all
      end
      model = @ajax.class.model_name.human
      img_path   = @ajax.icon_url(:icon).to_s
      @ajax = @ajax.attributes
      @ajax.store(:model,model)
      @ajax.store(:img_path, File.join(root_path, img_path))
    rescue
      @ajax = {
        "model"   => I18n.t("model"  , :scope => "ajax.message"),
        "name"    => I18n.t("name"   , :scope => "ajax.message"),
        "caption" => I18n.t("caption", :scope => "ajax.message")
      }
    end
    
    respond_to do |format|
      format.html { redirect_to root_path } # search.html.erb
      format.json { render json: @ajax }
    end
  end
  # GET /ajax_user(/:id)
  # GET /ajax_user(/:id).json
  def user
    user_name = User.where(:id => params[:id]).first.try(:name)
    
    user_data = {
      id: params[:id],
      name: user_name
    }
    
    respond_to do |format|
      format.html { redirect_to root_path } # search.html.erb
      format.json { render json: user_data }
    end
  end
  # GET /ajax_icon(/:id)
  # GET /ajax_icon(/:id).json
  def icon
    icon_data = User.where(:id => params[:id]).first.try(:icons)
    
    respond_to do |format|
      format.html { redirect_to root_path } # search.html.erb
      format.json { render json: icon_data }
    end
  end
end
