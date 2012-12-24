# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module HitRate
        
        def 自分
          @active
        end
        
        def 対象
          @passive
        end
        
        def hit_physical
          lambda{ 自分. HIT.to_f/(自分. HIT.to_f + 対象. EVA.to_f) }
        end
        
        def hit_magical
          lambda{ 自分.MHIT.to_f/(自分.MHIT.to_f + 対象.MEVA.to_f) }
        end
        
        def hit_physical_magical
          lambda{ (hit_physical.call + hit_magical.call)/2.to_f }
        end
        
        def hit_element
          lambda{ 1.to_f }
        end
        
      end
    end
  end
end
