# encoding: UTF-8
require 'pp'
class TestsController < ApplicationController
  layout "no_side"
  
  def battle
    @words = ["PT編成定義"]
    @text  = params[:text]
    @type  = :battle
    if @text.present?
      begin
        tree = parser.pt_settings.parse(@text)
        tree = transform.apply(tree)
        character = DNU::Fight::State::Character.new(tree)
        battle = DNU::Fight::Scene::Battle.new(character)
        history = battle.play
        @result = history.to_html + "<pre>#{tree.pretty_inspect}</pre>" + "<pre>#{history.pretty_inspect}</pre>"
      rescue => msg
        @error = msg
      end
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
  
  def ability
    @words = ["アビリティ定義"]
    @text  = params[:text]
    @type  = :ability
    parse_from_text(:ability)
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
  
  def parser
    @parser ||= EffectParser.new
  end
  
  def transform
    @transform ||= EffectTransform.new
  end
  
  def pt_text
    @pt_text ||= <<-"PT"
[PT]自分たち
[PC]自分
[PC]味方Ａ
[PC]味方Ｂ

[PT]モンスターズ
[モンスター]敵Ａ
[モンスター]敵Ｂ
[モンスター]敵Ｃ
    PT
  end
  
  def pt_character(tree)
    if @pt_character.nil?
      name = tree[:name]
      kind = tree[:kind].values.first
      pt_character_text = <<-"PT"
#{@text}

[PT]Ａチーム
[#{kind}]#{name}

[PT]Ｂチーム
[#{kind}]#{name}
      PT
      @pt_character = DNU::Fight::State::Character.new(transform.apply(parser.pt_settings.parse(pt_character_text)))
    end
    @pt_character
  end
  
  def characters
    @characters ||= DNU::Fight::State::Character.new(transform.apply(parser.pt_settings.parse(pt_text)))
  end
  
  def es(tree)
    @es ||= "DNU::Fight::State::#{@type.to_s.camelize}".constantize.new(tree)
  end
  
  def es_effects(tree)
    if @es_effects.nil?
      @es_effects = Struct.new(:id,:type,:name,:do,:interrupt,:LV,:history,:definitions).new
      @es_effects.type    = :"未定義"
      @es_effects.name    = :"特殊効果内容"
      @es_effects.do      = tree
      @es_effects.history = []
    end
    @es_effects
  end
  
  def parent
    if @parent.nil?
      @parent = Struct.new(:active,:passive,:label,:history,:pool,:stack).new
      active_now = characters.first
      @parent.active = lambda{ active_now }
    end
    @parent
  end
  
  def history_html_skill(tree)
    html = ""
    es(tree).each do |e|
      html += DNU::Fight::Scene::Effects.new(characters, { :effects => e }, parent).play.to_html
    end
    html
  end
  
  def history_html_effects(tree)
    history = DNU::Fight::Scene::Effects.new(characters, { :effects => es_effects(tree) }, parent).play
    history.to_html + "<pre>#{history.pretty_inspect}</pre>"
  end
  
  def history_html_sup(tree)
    html = ""
    lv = rand(6)
    tree.merge!(:lv => lv) if lv>=1
    es(tree).each do |e|
      html += "DNU::Fight::Scene::#{e.before_after}".constantize.new(characters, { :parent => e.timing, :effects => e, :b_or_a => e.before_after }, parent).play.to_html
    end
    html
  end
  
  def history_html_ability(tree)
    html = ""
    lv = rand(40)+1
    tree.merge!(:lv => lv) if lv>=1
    es(tree).each do |e|
      html += "DNU::Fight::Scene::#{e.before_after}".constantize.new(characters, { :parent => e.timing, :effects => e, :b_or_a => e.before_after }, parent).play.to_html
    end
    html
  end
  
  def history_html_character(tree)
    DNU::Fight::Scene::Battle.new(pt_character(tree)).play.to_html
  end
  
  def parse_from_text(type, name = :definition)
    if @text.present?
      begin
        tree = parser.send("#{type}_#{name}").parse(@text)
        tree = transform.apply(tree)
        @result = send("history_html_#{@type}", tree) + "<pre>#{tree.pretty_inspect}</pre>"
      rescue => msg
        @error = msg
      end
    end
    render 'test'
  end
  
end
