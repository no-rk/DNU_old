# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Effects < BaseScene
        
        def when_initialize
          @effects = { ("effects" + self.object_id.to_s).to_sym => nil }
        end
        
        def before_each_scene
          @label[:effects].try(:push, @effects) || @label[:effects] = [ @effects ]
        end
        
        # 構文木
        def before_create_children
          parser    = EffectParser.new
          transform = EffectTransform.new
          if rand(100)<50
            @tree ||= transform.apply(parser.parse("自/[自分HP20%以下]MHP増加(MHP×0.5+1000):味ラ/物理攻撃(3.0)×3"))
          else
            @tree ||= transform.apply(parser.parse("敵ラ/物理攻撃(0.5)"))
          end
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
