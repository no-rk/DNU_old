class Communication::ApplicationController < ApplicationController
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

    begin
      @recipients = User.find(params[name][:recipients].split(','))
    rescue
      @recipients = nil
    end

    #この処理をコントローラー毎に変化させる
    @receipts = send_communications(@recipients, params[name][:subject], params[name][:body]) if @recipients

    if Notification.successful_delivery?(@receipts)
      current_user.mark_as_read(mailbox.notifications)
      redirect_to register_index_path, notice: "seikou"
    else
      redirect_to register_index_path, alert: "error"
    end
  end

  # PUT /communication/controller_name/1
  # PUT /communication/controller_name/1.json
  def update
    names = self.class.controller_name
    name  = names.singularize

    @conversation = current_user.mailbox.conversations.find_by_id(params[:id])
    @receipt = current_user.reply_to_conversation(@conversation, params[name][:body], params[name][:subject])

    if @receipt.conversation
      redirect_to eval("communication_#{name}_path(#{params[name][:conversation]})"), notice: "seikou"
    else
      redirect_to eval("communication_#{name}_path(#{params[name][:conversation]})"), alert: "sippai"
    end
  end

  # DELETE /communication/controller_name/1
  # DELETE /communication/controller_name/1.json
  def destroy
  end

  private
  def send_communications(recipients, subject, body)
    raise NotImplementedError
  end
end
