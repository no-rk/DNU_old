class ResultController < ApplicationController
  layout "result"
  
  # GET result(/:day)/eno/:id
  def eno
    @id  = params[:id].to_i
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    this_user = User.find(@id)
    @creation_day = this_user.creation_day.to_i
    @passed_day = @day_i - @creation_day
    @profile  = this_user.result_character(@day_i).profile
    @guardian = this_user.result_guardian
    @place    = this_user.result(:place,   @day_i).first
    @job      = this_user.result(:job,     @day_i).first
    @points   = this_user.result(:point,   @day_i).all
    @statuses = this_user.result(:status,  @day_i).all
    @arts     = this_user.result(:art,     @day_i).all
    @products = this_user.result(:product, @day_i).all
    @skills   = this_user.result(:skill,   @day_i).all
  end
  
  # GET result(/:day)/map/:name
  def map
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    @user_counts = @map.user_counts
    @x = @map.map.map_tips.maximum(:x).to_i
    @y = @map.map.map_tips.maximum(:y).to_i
  end
  
  # GET result(/:day)/mapimage/:name
  def mapimage
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    send_data(@map.try(:image), :disposition => "inline", :type => "image/png")
  end
end
