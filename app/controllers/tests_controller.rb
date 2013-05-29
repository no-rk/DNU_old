# encoding: UTF-8
require 'pp'
class TestsController < ApplicationController
  layout "no_side"
  
  def message
    @sample = <<-"SAMPLE"
右側にある【エディタ】ボタンを押すとエディタとプレビュー画面が出てくる。
<右>右側に
<無>アイコン無し
<通><自分>「吹き出し無し」
<右無通>右側にアイコン吹き出し無し
    SAMPLE
  end
  
  def document
    @sample = <<-"SAMPLE"
右側にある【エディタ】ボタンを押すとエディタとプレビュー画面が出てくる。
<左寄赤><改行>
<左寄橙><改行>
<左寄黄><改行>
<左寄緑><改行>
<左寄青><改行>
<左寄藍><改行>
<左寄紫><改行>
<2段組><左寄>左側に左寄せ<左寄>右側に左寄せ
<3段組><左寄>左側に左寄せ<中寄>中央に中寄せ<右寄>右側に右寄せ
    SAMPLE
  end
  
  def parse
    @words = [I18n.t(params[:type].to_s.camelize, :scope => "DNU.Fight.Scene")]
    @type  = :parse
    @text  = params[:text]
    if @text.present?
      begin
        tree = DNU::Data.parse!(params[:type], @text, true)
        @result = "<pre>#{tree.pretty_inspect}</pre>"
      rescue => msg
        @error = msg
      end
    end
    render 'test'
  end
  
  def battle
    @words = ["PT編成定義"]
    @text  = params[:text]
    @type  = :battle
    if @text.present?
      #begin
        tree = DNU::Data.parse!(:pt_settings, @text, true)
        character = DNU::Fight::State::Characters.new(tree)
        battle = DNU::Fight::Scene::Battle.new(character)
        history = battle.play
        @result = "#{history.to_html}<pre>#{history.pretty_inspect}</pre><pre>#{tree.pretty_inspect}</pre>"
      #rescue => msg
      #  @error = msg
      #end
    end
    render 'test'
  end
  
  def character
    @words = ["キャラクター定義"]
    @text  = params[:text]
    @type  = :character
    parse_from_text(:character)
  end
  
  def sup
    @words = ["付加定義"]
    @text  = params[:text]
    @type  = :sup
    parse_from_text(:sup)
  end
  
  def art_effect
    @words = ["技能効果定義"]
    @text  = params[:text]
    @type  = :art_effect
    parse_from_text(:art_effect)
  end
  
  def skill
    @words = ["技定義"]
    @text = params[:text]
    @type  = :skill
    parse_from_text(:skill)
  end
  
  def effects
    @words = ["特殊効果内容"]
    @text  = params[:text]
    @type  = :effects
    parse_from_text(:root, :processes)
  end
  
  private
  def pt_text
    @pt_text ||= <<-"PT"
[PC]自分/1
[PC]味方A/1
[PC]味方B/1

[PT]自分たち
[PC]自分
[PC]味方A
[PC]味方B

[PT]モンスターズ
[モンスター]キュアプルプル
[モンスター]ピコピコテール
[モンスター]酔いどれドラゴン
    PT
  end
  
  def pt_character(tree)
    if @pt_character.nil?
      name = tree[:name]
      kind = tree[:kind]
      pt_character_text = <<-"PT"
#{@text}

[PT]Ａチーム
[#{kind}]#{name}

[PT]Ｂチーム
[#{kind}]#{name}-1

[PT]Ｃチーム
[#{kind}]#{name}+1
      PT
      @pt_character = DNU::Fight::State::Characters.new(DNU::Data.parse_settings(:pt, pt_character_text, true))
    end
    @pt_character
  end
  
  def characters
    @characters ||= DNU::Fight::State::Characters.new(DNU::Data.parse_settings(:pt, pt_text, true))
  end
  
  def es(tree)
    @es ||= "DNU::Fight::State::#{@type.to_s.camelize}".constantize.new(tree)
  end
  
  def parent
    if @parent.nil?
      @parent = Struct.new(:active,:passive,:label,:history,:pool,:stack,:data).new
      active_now = characters.first
      @parent.active = lambda{ active_now }
    end
    @parent
  end
  
  def history_html_character(tree)
    history = DNU::Fight::Scene::Battle.new(pt_character(tree)).play
    history.to_html + "<pre>#{history.pretty_inspect}</pre>"
  end
  
  def history_html_skill(tree)
    html = ""
    es(tree).each do |e|
      html += %Q|<span class="badge">#{e.hostility ? "敵に影響を与える技" : "敵に影響を与えない技"}</span>|
      history = DNU::Fight::Scene::Effects.new(characters, { :effects => e }, parent).play
      html += history.to_html + "<pre>#{history.pretty_inspect}</pre>"
    end
    html
  end
  
  def history_html_sup(tree)
    html = ""
    lv = rand(6)
    tree.merge!(:lv => lv) if lv>=1
    es(tree).each do |e|
      history = "DNU::Fight::Scene::#{e.before_after || :Children}".constantize.new(characters, { :parent => e.timing, :effects => e, :b_or_a => (e.before_after || :Children) }, parent).play
      html += history.to_html + "<pre>#{history.pretty_inspect}</pre>"
    end
    html
  end
  
  def history_html_art_effect(tree)
    html = ""
    lv = rand(40)+1
    tree.merge!(:lv => lv) if lv>=1
    es(tree).each do |e|
      history = "DNU::Fight::Scene::#{e.before_after || :Children}".constantize.new(characters, { :parent => e.timing, :effects => e, :b_or_a => (e.before_after || :Children) }, parent).play
      html += history.to_html + "<pre>#{history.pretty_inspect}</pre>"
    end
    html
  end
  
  def history_html_effects(tree)
    tree = {
      :name    => :"名称未定義",
      :effects => [ { :do => tree } ]
    }
    e = DNU::Fight::State::BaseEffects.new(tree).first
    history = DNU::Fight::Scene::Effects.new(characters, { :effects => e }, parent).play
    history.to_html + "<pre>#{history.pretty_inspect}</pre>"
  end
  
  def parse_from_text(type, name = :definition)
    if @text.present?
      #begin
        tree = DNU::Data.parse!("#{type}_#{name}", @text, true)
        @result = send("history_html_#{@type}", tree) + "<pre>#{tree.pretty_inspect}</pre>"
      #rescue => msg
      #  @error = msg
      #end
    end
    render 'test'
  end
  
end
