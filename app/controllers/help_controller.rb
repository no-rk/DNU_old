# encoding: UTF-8
class HelpController < ApplicationController
  def index
    keywords = {
      "戦闘値"           => ["戦闘値", "戦闘値一覧"],
      "PT編成定義"       => ["PT編成定義", "キャラクター定義", "アビリティ設定", "付加設定", "技設定"],
      "キャラクター定義" => ["キャラクター定義", "アビリティ設定", "付加設定", "技設定"],
      "アビリティ定義"   => ["アビリティ定義"],
      "付加定義"         => ["付加定義"],
      "技定義"           => ["技定義"],
      "特殊効果内容"     => ["特殊効果内容", "効果", "対象", "発動条件", "効果種", "停止条件", "効果条件"]
    }
    @link = {
      "PT編成定義"       => tests_battle_path,
      "キャラクター定義" => tests_character_path,
      "アビリティ定義"   => tests_ability_path,
      "付加定義"         => tests_sup_path,
      "技定義"           => tests_skill_path,
      "特殊効果内容"     => tests_effects_path
    }
    @keys  = keywords.keys
    @name  = params[:name]
    @words = keywords[params[:name]]
  end

  def show
    tx_map = Tx::Map.open("#{Rails.root}/db/game_data/dnu")
    model = params[:model]
    id    = params[:id]
    begin
      data = "GameData::#{model.classify}".constantize.select([:name, :caption]).find(id)
      @word    = data.name
      @caption = tx_map.add_link(data.caption, data.name, :remote)
    rescue
      redirect_to root_path
    end
  end
end
