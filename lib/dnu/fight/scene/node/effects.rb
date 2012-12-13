# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Effects < BaseScene
        
        #構文木
        def create_children
          parser    = EffectParser.new
          transform = EffectTransform.new
          @tree = parser.parse("自/[自分HP20%以下]MHP増加(MHP×0.5+1000):味ラ/物理攻撃(3.0)×3")
          @tree = transform.apply(@tree)
          super
        end
        
      end
    end
  end
end
