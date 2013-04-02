class ResultController < ApplicationController
  layout "result"
  
  # GET result(/:day)/eno/:id
  def eno
    @id  = params[:id].to_i
    @day = (params[:day] || Day.last_day_i).to_i
    
    this_user = User.find(@id)
    @passed_day = @day - this_user.creation_day.to_i
    @profile = this_user.character(@day).profile
  end
end
