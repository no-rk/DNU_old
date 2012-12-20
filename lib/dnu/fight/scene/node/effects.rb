# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Effects < BaseScene
        
        def when_initialize
          @effects = { ("effects" + self.object_id.to_s).to_sym => nil }
        end
        
        def before_each_scene
          @children = nil
          @label[:effects].try(:push, @effects) || @label[:effects] = [ @effects ]
        end
        
        # 構文木
        def before_create_children
          parser    = EffectParser.new
          transform = EffectTransform.new
          @tree ||= transform.apply(parser.parse("自/[自分HP20%以下]HP回復(MHP×0.05+300):敵単/SW物魔攻撃(1.0)"))
        end
        
        def play_children
          catch @effects.keys.first do
            super
          end
        end
        
      end
    end
  end
end
