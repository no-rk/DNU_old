class AjaxController < ApplicationController
  # GET /ajax/:model(/:id)
  # GET /ajax/:model(/:id).json
  def search
    begin
      if params[:id]
        @ajax = "GameData::#{params[:model].classify}".split("::").inject(Object){ |oldclass, name| oldclass.const_get(name) }.select([:name,:caption]).find(params[:id])
      else
        @ajax = "GameData::#{params[:model].classify}".split("::").inject(Object){ |oldclass, name| oldclass.const_get(name) }.select([:id,:name,:caption]).all
      end
      model = @ajax.class.model_name.human.downcase
      @ajax = @ajax.attributes
      @ajax.store(:model,model)
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
end
