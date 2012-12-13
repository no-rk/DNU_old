# encoding: UTF-8
require 'parslet' 
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

def duel
  DNU::Fight::Scene::Duel.new(DNU::Fight::State::Character.new)
end

def reload!
  load '/home/nork/rails/DNU/lib/dnu.rb'
  @parser    = nil
  @transform = nil
  "reload dnu"
end
