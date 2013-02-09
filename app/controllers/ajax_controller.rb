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
      model = @ajax.class.model_name.human.downcase
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

  # POST /ajax_html_to
  # POST /ajax_html_to.json
  def html_to
    html = params[:html]

    @ajax = Hash.new
    @ajax[:code] = DNU::Sanitize.html_to_code(html)

    respond_to do |format|
      format.html { redirect_to root_path } # search.html.erb
      format.json { render json: @ajax }
    end
  end

  # POST /ajax_to_html
  # POST /ajax_to_html.json
  def to_html
    code = params[:code]

    @ajax = Hash.new
    san = DNU::Sanitize.new(current_user)
    @ajax[:html] = san.code_to_html(code)

    respond_to do |format|
      format.html { redirect_to root_path } # search.html.erb
      format.json { render json: @ajax }
    end
  end
end
