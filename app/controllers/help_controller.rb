# encoding: UTF-8
class HelpController < ApplicationController
  def index
    keywords = {
      "戦闘値"           => ["戦闘値", "戦闘値一覧"],
      "PT編成定義"       => ["PT編成定義", "キャラクター定義", "技能設定", "付加設定", "技設定"],
      "キャラクター定義" => ["キャラクター定義", "技能設定", "付加設定", "技設定"],
      "技能効果定義"     => ["技能効果定義"],
      "付加定義"         => ["付加定義"],
      "技定義"           => ["技定義"],
      "特殊効果内容"     => ["特殊効果内容", "効果", "対象", "発動条件", "効果種", "停止条件", "効果条件"],
      "戦闘設定"         => ["戦闘設定", "戦闘設定例"],
      "戦闘構造"         => ["戦闘構造"],
      "イベント定義"     => ["イベント定義", "イベント種類", "イベント名", "イベント説明", "イベントステップ", "イベントタイミング", "イベントコンディション", "イベントコンテンツ", "イベント定義例"]
    }
    @link = {
      "PT編成定義"       => tests_battle_path,
      "キャラクター定義" => tests_character_path,
      "技能効果定義"     => tests_art_effect_path,
      "付加定義"         => tests_sup_path,
      "技定義"           => tests_skill_path,
      "特殊効果内容"     => tests_effects_path,
      "イベント定義"     => tests_parse_path(:event_definition)
    }
    @keys  = keywords.keys
    @name  = params[:name]
    @words = keywords[params[:name]]
  end
  
  def model
    model = params[:model]
    id    = params[:id]
    
    begin
      model   = "GameData::#{model.camelize}".constantize.find(id)
      @name   = model.name
      caption = model.caption
    rescue
      respond_to do |format|
        format.html{ redirect_to root_path }
        format.json do
          json = {
            name: I18n.t("name", :scope => "ajax.message"),
            captions: [{
              model_name: I18n.t("model",   :scope => "ajax.message"),
              caption:    I18n.t("caption", :scope => "ajax.message")
            }]
          }
          render json: json
        end
      end
    else
      tx_map = Tx::Map.open("#{Rails.root}/db/game_data/dnu")
      data   = JSON.parse(tx_map[@name])
      
      @captions = [{
        model_name:  model.class.model_name.human,
        caption:     tx_map.add_link(caption, @name, :remote)
      }]
      
      respond_to do |format|
        format.html{ render action: "show" }
        format.json do
          json = {
            name:     @name,
            captions: @captions
          }
          render json: json
        end
      end
    end
  end
  
  def show
    @name = params[:name]
    
    tx_map = Tx::Map.open("#{Rails.root}/db/game_data/dnu")
    data   = JSON.parse(tx_map[@name])
    
    if data.present?
      @captions = []
      
      data.each do |h|
        @captions.push({
          model_name:  h["model"].constantize.model_name.human,
          caption:     tx_map.add_link(h["model"].constantize.find(h["id"]).caption, @name, :remote)
        })
      end
      
      respond_to do |format|
        format.html
        format.json do
          json = {
            name:     @name,
            captions: @captions
          }
          render json: json
        end
      end
    else
      respond_to do |format|
        format.html{ redirect_to root_path }
        format.json do
          json = {
            name:     I18n.t("name"   , :scope => "ajax.message"),
            captions: I18n.t("caption", :scope => "ajax.message")
          }
          render json: json
        end
      end
    end
  end
end
