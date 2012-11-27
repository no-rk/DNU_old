class Communication::ApplicationController < ApplicationController
  helper_method :communication
  before_filter :authenticate_user!
  before_filter :make_check
  layout "register"

  # GET /communication/controller_name
  # GET /communication/controller_name.json
  def index
  end

  # GET /communication/controller_name/1
  # GET /communication/controller_name/1.json
  def show
  end

  # GET /communication/controller_name/new
  # GET /communication/controller_name/new.json
  def new
  end

  # GET /communication/controller_name/1/edit
  def edit
  end

  # POST /communication/controller_name
  # POST /communication/controller_name.json
  def create
    names = self.class.controller_name
    name  = names.singularize

    if communication.valid?
      begin
        @recipients = User.where(:id => params["communication_#{name}"][:recipients].split(',') )
      rescue
        @recipients = nil
      end

      #サニタイズ
      subject = ::Sanitize.clean(params["communication_#{name}"][:subject])
      body    = DNU::Sanitize.code_to_code(params["communication_#{name}"][:body])
      #この処理をコントローラー毎に変化させる
      @receipts = send_communications(@recipients, subject, body) if @recipients

      if Notification.successful_delivery?(@receipts)
        redirect_to register_index_path, notice: "seikou"
      else
        redirect_to register_index_path, alert: "error"
      end
    else
      render action: "new"
    end
  end

  # PUT /communication/controller_name/1
  # PUT /communication/controller_name/1.json
  def update
  end

  # DELETE /communication/controller_name/1
  # DELETE /communication/controller_name/1.json
  def destroy
  end

  private
  def send_communications(recipients, subject, body)
    raise NotImplementedError
  end
  def communication
    names = self.class.controller_name
    name  = names.singularize

    @communication ||= eval ("Communication::#{names.classify}.new(params[:communication_#{name}])")
  end
end
