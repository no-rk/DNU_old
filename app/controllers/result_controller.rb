class ResultController < ApplicationController
  # GET result
  def index
    @title = "結果"
  end
  
  # GET result/enos(/:new)
  def enos
    @title = "個人結果一覧"
    if params[:new].try(:to_sym) == :new
      @users = User.new_commer.page(params[:page]).per(10)
    else
      @users = User.already_make.page(params[:page]).per(10)
    end
  end
  
  # GET result/maps
  def maps
    @title = "マップ一覧"
    @maps = GameData::Map.already_make.page(params[:page]).per(10)
  end
  
  # GET result(/:day)/eno/:id
  def eno
    @id  = params[:id].to_i
    @day_i = (params[:day] || Day.last_day_i).to_i
    @title = "ENo.#{@id}の第#{@day_i}回の結果"
    
    this_user = User.find(@id)
    @creation_day  = this_user.creation_day.to_i
    @passed_day    = @day_i - @creation_day
    @max_inventory = this_user.max_inventory(@day_i)
    # 日記
    @diary        = this_user.register(:main, @day_i).try(:diary).try(:diary)
    # アイテム破棄
    @disposes     = this_user.result(:dispose, @day_i).includes(:dispose).includes(:item).all
    # 送信ポイント
    @send_points  = this_user.result(:send_point, @day_i).includes(:send_point).includes(:point).includes(:to).all
    # 受信ポイント
    @receive_points = Result::SendPoint.receives(@id, @day_i).all
    # 送信アイテム
    @send_items   = this_user.result(:send_item, @day_i).includes(:to).all
    # 受信アイテム
    @receive_items = Result::SendItem.receives(@id, @day_i).all
    # 購入アイテム
    @purchases    = this_user.result(:purchase, @day_i).all
    # 鍛治
    @forges       = this_user.result(:forge, @day_i).all
    # 付加
    @supplements  = this_user.result(:supplement, @day_i).all
    # 装備
    @equips       = this_user.result(:equip, @day_i).all
    # 戦闘
    @battle       = this_user.result(:battle, @day_i).first
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
    # 移動後
    @after_moves  = this_user.result(:after_move, @day_i)
    # 戦闘予告
    @notice       = this_user.result(:notice, @day_i).includes(:party).includes(:enemy).first
    # 叫び
    @shouts       = this_user.result(:shout, @day_i).all
    # キャラデータ
    @profile      = this_user.result(:character, @day_i).profile
    @guardian     = this_user.result(:guardian,  @day_i)
    @place        = this_user.result(:place,     @day_i).includes(:map_tip).includes(:map).first
    @points       = this_user.result(:point,     @day_i).includes(:point).all
    @statuses     = this_user.result(:status,    @day_i).includes(:status).all
    @arts         = this_user.result(:art,       @day_i).where(:forget => false).includes(:art).all
    @products     = this_user.result(:product,   @day_i).where(:forget => false).includes(:product).all
    @abilities    = this_user.result(:ability,   @day_i).where(:forget => false).includes(:ability).all
    @skills       = this_user.result(:skill,     @day_i).where(:forget => false).includes(:skill).all
    @inventories  = this_user.result(:inventory, @day_i).includes(:type).includes(:result_equips).order(:number).all
    @events       = this_user.result(:event, @day_i).where(GameData::Event.arel_table[:kind].in(["共通", "通常"])).includes(:event).all
    
    render :layout => 'plain'
  end
  
  # GET result(/:day)/item/:id
  def item
    @id  = params[:id].to_i
    @day_i = (params[:day] || Day.last_day_i).to_i
    @title = "アイテムID：#{@id}の第#{@day_i}回の結果"
    
    @item = Result::Item.find(@id)
    @item_passed_days = @item.passed_days_lteq_day_i(@day_i).page(params[:page]).per(10)
    
    render :layout => 'plain'
  end
  
  # GET result(/:day)/map/:name
  def map
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    @title = "#{@name}の第#{@day_i}回の結果"
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    @creation_day = @map.creation_day
    @passed_day   = @day_i - @creation_day
    @user_counts = @map.user_counts
    @x = @map.map_tips.maximum(:x).to_i
    @y = @map.map_tips.maximum(:y).to_i
    
    render :layout => 'plain'
  end
  
  # GET result(/:day)/map/:name/:x/:y
  def map_detail
    @name = params[:name]
    @day_i = (params[:day] || Day.last_day_i).to_i
    @x = params[:x].to_i
    @y = params[:y].to_i
    @title = "#{@name} #{('A'.ord-1+@x).chr}#{@y}の第#{@day_i}回の結果"
    
    @map = Result::Map.find_by_name_and_day_i(@name, @day_i).first
    @creation_day = @map.creation_day
    @passed_day   = @day_i - @creation_day
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
