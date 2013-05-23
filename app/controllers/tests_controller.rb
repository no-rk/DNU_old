# encoding: UTF-8
require 'pp'
class TestsController < ApplicationController
  layout "no_side"
  
  def message
  end
  
  def document
    @example = <<-"EXAMPLE"
<複3>
<右寄>むかしむかし、<右寄>人間も生まれていない、<右寄>大むかしのある年の暮れの事です。
<複2>
<右寄>神さまが、<右寄>動物たちに言いました。

<1><神様>もうすぐ正月だ。<元旦>^<ガンタン>には、みんな私の所に来なさい。
そして、先に来た者から十二番目までを、その年の大将としよう。
<右寄>
ところが、うっかり者の<下>ネコ<下>は集まる日を忘れたので、友だちの<消>ネズミ<消>に聞きました。
するとネズミは、

<右1><ネズミ>ああ、新年の二日だよ。
<右寄>
と、<太>わざとうそを教えました。
<中寄>
さて、元旦になりました。
ウシは足が遅いので、朝早くに家を出ました。
ちゃっかり者のネズミは、こっそりウシの背中に乗って神さまの前に来ると、
ピョンと飛び降りて一番最初に神さまの前に行きました。
それでネズミが最初の年の大将になり、ウシが二番目になりました。

その後、トラ・ウサギ・タツ・ヘビ・ウマ・ヒツジ・サル・ニワトリ・イヌ・イノシシの順になりました。
ところがネコは、ネズミに教えられた通り二日に神さまの所へ行きました。

<左寄>
すると神さまは、

<1><神様>遅かったね。残念だけど、昨日決まったよ
<左寄>
と、言うではありませんか。
<太><斜>くやしいのなんの。

<右1><ネコ>ネズミめ、よくも騙したな！
<中寄>怒ったネコは、それからずっと、ネズミを見ると追いかける様になりました。

<絵1>

<中寄>
<大><大><大>お<元>しまい
    EXAMPLE
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
