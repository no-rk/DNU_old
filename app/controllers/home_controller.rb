class HomeController < ApplicationController
  def index
    Day.toggle_settled_pending
  end
end
