# encoding: UTF-8
require 'pp'
class TestsController < ApplicationController
  layout "no_side"
  
  def battle
    @words = ["PT編成定義"]
    @text = params[:text]
    if @text.present?
      begin
        parser = EffectParser.new
        tree = parser.pt_settings.parse(@text)
        transform = EffectTransform.new
        tree = transform.apply(tree)
        character = DNU::Fight::State::Character.new(tree)
        battle = DNU::Fight::Scene::Battle.new(character)
        history = battle.play
        @result = history.to_html
      rescue => msg
        @error = msg
      end
    end
  end
  
  def character
    @words = ["キャラクター定義"]
    @text = params[:text]
    parse_from_text(:character)
  end
  
  def sup
    @words = ["付加定義"]
    @text = params[:text]
    parse_from_text(:sup)
  end
  
  def ability
    @words = ["アビリティ定義"]
    @text = params[:text]
    parse_from_text(:ability)
  end
  
  def skill
    @words = ["技定義"]
    @text = params[:text]
    parse_from_text(:skill)
  end
  
  def effects
    @words = ["特殊効果内容"]
    @text = params[:text]
    parse_from_text(:root, :processes)
  end
  
  private
  
  def parse_from_text(type, name = :definition)
    if @text.present?
      begin
        parser = EffectParser.new
        tree = parser.send("#{type}_#{name}").parse(@text)
        transform = EffectTransform.new
        tree = transform.apply(tree)
        @result = "<pre>#{tree.pretty_inspect}</pre>"
      rescue => msg
        @error = msg
      end
    end
  end
  
end
