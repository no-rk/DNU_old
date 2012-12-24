# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Damage
        
        def 自分
          @active
        end
        
        def 対象
          @passive
        end
        
        def dmg_physical
          lambda{ 自分. AT.to_f - 対象. DF.to_f/2 }
        end
        
        def dmg_magical
          lambda{ 自分.MAT.to_f - 対象.MDF.to_f/2 }
        end
        
        def dmg_physical_magical
          lambda{ (dmg_physical.call + dmg_magical.call)/2.to_f }
        end
        
        def dmg_element
          lambda{ 1.to_f }
        end
        
      end
    end
  end
end
