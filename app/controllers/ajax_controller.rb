class AjaxController < ApplicationController
  # GET /ajax_help/:model(/:id)
  # GET /ajax_help/:model(/:id).json
  def help
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

  # GET /ajax_img/:model(/:id)
  # GET /ajax_img/:model(/:id).json
  def img
    begin
      if params[:id]
        @ajax = "Register::#{params[:model].classify}".split("::").inject(Object){ |oldclass, name| oldclass.const_get(name) }.find(params[:id])
      else
        @ajax = "Register::#{params[:model].classify}".split("::").inject(Object){ |oldclass, name| oldclass.const_get(name) }.all
      end
      model = @ajax.class.model_name.human.downcase
      img_path   = @ajax.icon_url(:icon)
      @ajax = @ajax.attributes
      @ajax.store(:model,model)
      @ajax.store(:img_path,img_path)
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
    if html.blank?
      @ajax[:code] = ""
    else
      @ajax[:code] = html
      doc = Nokogiri.HTML(@ajax[:code])
      doc.css('p,div').each do |br|
        br.swap(Nokogiri::HTML::fragment('<br>' + br.inner_html))
      end
      logger.debug(doc)
      @ajax[:code] = doc.to_html
      @ajax[:code] = ::Sanitize.clean(@ajax[:code],:elements=>['b','i','u','strike','s','ruby','rb','rt','img','br'],:attributes=>{'img'=>['no']})
      @ajax[:code].gsub!(/[\r\n]+/,"")
      @ajax[:code].gsub!(/<br.*?>/,"\n")
      @ajax[:code].sub!(/^\n/,"")
    end

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
    if code.blank?
      @ajax[:html] = ""
    else
      @ajax[:html] = code
      @ajax[:html].gsub!(/[\r\n]+/,'<br>')
      doc = Nokogiri.HTML(@ajax[:html])
      doc.css('img').each do |img|
        img.set_attribute('src',current_user.icons[img.attribute('no').value.to_i]) unless current_user.icons[img.attribute('no').value.to_i].nil?
        img.set_attribute('class','icon')
      end
      @ajax[:html] = doc.to_html
      @ajax[:html] = ::Sanitize.clean(@ajax[:html],:elements=>['b','i','u','strike','s','ruby','rb','rt','img','br'],:attributes=>{'img'=>['no','src','class']})
      @ajax[:html].gsub!(/[\r\n]+/,"")
      @ajax[:html].sub!(/^<br.*?>/,"")
    end


    respond_to do |format|
      format.html { redirect_to root_path } # search.html.erb
      format.json { render json: @ajax }
    end
  end
end
