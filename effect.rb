require 'parslet' 
load '/home/nork/rails/DNU/lib/dnu/fight/scene/effect/effect_parser.rb'
load '/home/nork/rails/DNU/lib/dnu/fight/scene/effect/effect_transform.rb'

def parser
  @parser ||= EffectParser.new
end

def transform
  @transform ||= EffectTransform.new
end

def reload!
  load '/home/nork/rails/DNU/lib/dnu/fight/scene/effect/effect_parser.rb'
  load '/home/nork/rails/DNU/lib/dnu/fight/scene/effect/effect_transform.rb'
  @parser = nil
  @transform = nil
  "reload effect"
end
