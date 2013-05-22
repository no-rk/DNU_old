class ChatsController < ApplicationController
  def index
    @namespace = "chat"
    @room      = params[:room]
    @comments  = Chat.where(:namespace => @namespace, :room => @room).select([:data, :updated_at]).order("updated_at desc").page(params[:page]).per(10)
    
    @chat = Chat.new
  end
  
  def create
    chat = Chat.create!(params[:chat])
    respond_to do |format|
      format.html{ redirect_to chats_path }
      format.json{ render json: chat.updated_at.try(:to_s, :jp).try(:to_json) }
    end
  end
end
