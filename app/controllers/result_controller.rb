class ResultController < ApplicationController
  layout "result"
  
  # GET result(/:day)/eno/:id
  def eno
    @id  = params[:id].to_i
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    this_user = User.find(@id)
    @passed_day = @day_i - this_user.creation_day.to_i
    @profile  = this_user.result_character(@day_i).profile
    @job      = this_user.result(:job, @day_i).first
    @arts     = this_user.result(:art, @day_i).all
    @statuses = this_user.result(:status, @day_i).all
  end
end
