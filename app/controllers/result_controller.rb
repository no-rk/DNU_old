class ResultController < ApplicationController
  layout "result"
  
  # GET result(/:day)/eno/:id
  def eno
    @id  = params[:id].to_i
    @day = (params[:day] || Day.last_day_num).to_i
    
    this_user = User.find(@id)
    @passed_day = @day - this_user.creation_day.to_i
    @name = this_user.name
  end
end
