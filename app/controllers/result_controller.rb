class ResultController < ApplicationController
  layout "result"
  
  # GET result(/:day)/eno/:id
  def eno
    @day  = params[:day] || Day.last_day_num
    @id   = params[:id]
    @name = User.find(@id).name
  end
end
