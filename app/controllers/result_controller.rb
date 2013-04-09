class ResultController < ApplicationController
  # GET result
  def index
  end
  
  # GET result/enos(/:new)
  def enos
    if params[:new].try(:to_sym) == :new
      @users = User.new_commer.page(params[:page]).per(10)
    else
      @users = User.already_make.page(params[:page]).per(10)
    end
  end
  
  # GET result/maps
  def maps
    @maps = GameData::Map.page(params[:page]).per(10)
  end
  
  # GET result(/:day)/eno/:id
  def eno
    @id  = params[:id].to_i
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    this_user = User.find(@id)
    @creation_day = this_user.creation_day.to_i
    @passed_day = @day_i - @creation_day
    @profile   = this_user.result(:character, @day_i).profile
    @guardian  = this_user.result(:guardian,  @day_i)
    @place     = this_user.result(:place,     @day_i).first
    @job       = this_user.result(:job,       @day_i).where(:forget => false).first
    @party     = this_user.result(:party,     @day_i).first
    @points    = this_user.result(:point,     @day_i).all
    @statuses  = this_user.result(:status,    @day_i).all
    @arts      = this_user.result(:art,       @day_i).where(:forget => false).all
    @products  = this_user.result(:product,   @day_i).where(:forget => false).all
    @abilities = this_user.result(:ability,   @day_i).where(:forget => false).all
    @skills    = this_user.result(:skill,     @day_i).where(:forget => false).all
    
    render :layout => 'plain'
  end
  
  # GET result(/:day)/map/:name
  def map
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    @user_counts = @map.user_counts
    @x = @map.map.map_tips.maximum(:x).to_i
    @y = @map.map.map_tips.maximum(:y).to_i
    
    render :layout => 'plain'
  end
  
  # GET result(/:day)/map/:name/:x/:y
  def map_detail
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    @x = params[:x]
    @y = params[:y]
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    @map_tip = @map.map.map_tips.where(:x => @x, :y => @y).first
    @users = @map_tip.nil? ? [] : @map_tip.where_places_by_day_i(@day_i).map{ |r| r.user }
    render :layout => 'plain'
  end
  
  # GET result(/:day)/mapimage/:name
  def map_image
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    send_data(@map.try(:image), :disposition => "inline", :type => "image/png")
  end
end
