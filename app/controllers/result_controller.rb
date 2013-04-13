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
    # 送信ポイント
    @send_points  = this_user.result(:send_point, @day_i).includes(:send_point).includes(:point).includes(:to).all
    # 受信ポイント
    @receive_points = Result::SendPoint.receives(@id, @day_i).all
    # 送信アイテム
    @send_items   = this_user.result(:send_item, @day_i).includes(:to).all
    # 受信アイテム
    @receive_items = Result::SendItem.receives(@id, @day_i).all
    # 訓練
    @trains       = this_user.result(:train, @day_i).all
    # 習得
    @learns       = this_user.result(:learn, @day_i).all
    # 忘却
    @forgets      = this_user.result(:forget, @day_i).all
    # 開花
    @blossoms     = this_user.result(:blossom, @day_i).all
    # 移動
    @direction_list = { :'休' => 0, :'上' => 1, :'右' => 2, :'下' => 3, :'左' => 4 }.invert
    @moves        = this_user.result(:move, @day_i).includes(:from, :to).all
    # PT結成
    @party        = this_user.result(:party, @day_i).first
    # キャラデータ
    @profile      = this_user.result(:character, @day_i).profile
    @guardian     = this_user.result(:guardian,  @day_i)
    @place        = this_user.result(:place,     @day_i).includes(:map_tip).includes(:map).first
    @job          = this_user.result(:job,       @day_i).where(:forget => false).includes(:job).first
    @points       = this_user.result(:point,     @day_i).includes(:point).all
    @statuses     = this_user.result(:status,    @day_i).includes(:status).all
    @arts         = this_user.result(:art,       @day_i).where(:forget => false).includes(:art).all
    @products     = this_user.result(:product,   @day_i).where(:forget => false).includes(:product).all
    @abilities    = this_user.result(:ability,   @day_i).where(:forget => false).includes(:ability).all
    @skills       = this_user.result(:skill,     @day_i).where(:forget => false).includes(:skill).all
    @inventories  = this_user.result(:inventory, @day_i).includes(:type).order(:number).all
    
    render :layout => 'plain'
  end
  
  # GET result(/:day)/item/:id
  def item
    @id  = params[:id].to_i
    @day_i = (params[:day] || Day.last_day_i).to_i
    
    @item = Result::Item.find(@id)
    @item_passed_days = @item.passed_days_lteq_day_i(@day_i).page(params[:page]).per(10)
    
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
    @map_tip = @map.map_tips.where(:x => @x, :y => @y).first
    
    @user_ids = @map_tip.nil? ? [] : @map_tip.where_places_by_day_i(@day_i).map{ |r| r.user.id }
    @parties = Result::Party.where_user_ids_and_day_i(@user_ids, @day_i)
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
