class GameData::ApplicationController < ApplicationController
  before_filter :set_title
  layout "game_data"

  # GET /game_data/controller_name
  def index
    records = "GameData::#{controller_name.classify}".constantize.page(params[:page]).per(20)
    instance_variable_set("@#{controller_name}", records)
  end


  # GET /game_data/controller_name/new
  def new
    set_instance_variables
    record = "GameData::#{controller_name.classify}".constantize.new
    build_record(record)
    instance_variable_set("@#{controller_name.singularize}", record)
  end

  # GET /game_data/controller_name/1/edit
  def edit
    set_instance_variables
    record = "GameData::#{controller_name.classify}".constantize.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", record)
  end

  # POST /game_data/controller_name
  def create
    set_instance_variables
    
    record = "GameData::#{controller_name.classify}".constantize.new(params[:"game_data_#{controller_name.singularize}"])
    instance_variable_set("@#{controller_name.singularize}", record)
    
    if record.save
      redirect_to send("edit_game_data_#{controller_name.singularize}_path", record.id), :notice => "保存された。"
    else
      render action: "new"
    end
  end

  # PUT /game_data/controller_name/1
  def update
    set_instance_variables
    
    record = "GameData::#{controller_name.classify}".constantize.find(params[:id])
    record.assign_attributes(params[:"game_data_#{controller_name.singularize}"])
    instance_variable_set("@#{controller_name.singularize}", record)
    
    if record.save
      redirect_to send("edit_game_data_#{controller_name.singularize}_path", params[:id]), :notice => "更新された。"
    else
      render action: "edit"
    end
  end
  
  private
  def set_title
    @title = "GameData::#{controller_name.classify}".constantize.model_name.human
  end
  def set_instance_variables
  end
  def build_record(record)
  end
end
