# encoding: UTF-8
require 'parslet' 
require 'tx'
require 'i18n'
require 'active_support/core_ext'
def require_dependency(filename)
  load '/home/nork/rails/DNU/lib/' + filename + '.rb'
end
I18n.load_path += ['/home/nork/rails/DNU/config/locales/dnu.ja.yml']
I18n.locale     = :ja

load '/home/nork/rails/DNU/lib/dnu.rb'

def parser
  @parser ||= EffectParser.new
end

def transform
  @transform ||= EffectTransform.new
end

def character
pt = <<"PT"
[PT]NPCたち
[NPC]その１
[NPC]その２
[NPC]その３

[PT]モンスターズ
[モンスター]キュアプルプル
[モンスター]ピコピコテール
[モンスター]酔いどれドラゴン
PT
  @character ||= DNU::Fight::State::Character.new(transform.apply(EffectParser.new.pt_settings.parse(pt)))
end

def duel
  DNU::Fight::Scene::Duel.new(character)
end

def skill(text)
  tree = transform.apply(parser.parse(text))
  parent = Struct.new(:active,:passive,:label,:history).new
  parent.active = character.sample
  DNU::Fight::Scene::Effects.new(character, tree, parent)
end

def reload!
  load '/home/nork/rails/DNU/lib/dnu.rb'
  @parser    = nil
  @transform = nil
  @character = nil
  "reload dnu"
end
