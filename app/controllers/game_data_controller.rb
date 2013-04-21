class GameDataController < ApplicationController
  layout "game_data"
  
  def index
    @title = "ゲームデータ"
  end
end
