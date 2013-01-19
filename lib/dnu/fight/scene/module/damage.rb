# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Damage
        
        def 自分
          @active.call
        end
        
        def 対象
          @passive.try(:call) || @active.call
        end
        
        def dmg_physical
          lambda{ (自分. AT.next! || 自分. AT).to_f/2 - (対象. DF.next! || 対象. DF).to_f/4 }
        end
        
        def dmg_magical
          lambda{ (自分.MAT.next! || 自分.MAT).to_f/2 - (対象.MDF.next! || 対象.MDF).to_f/4 }
        end
        
        def dmg_physical_magical
          lambda{ (dmg_physical.call + dmg_magical.call)/2.to_f }
        end
        
        def dmg_element
          lambda{ 1.to_f }
        end
        
        def dmg_critical
          lambda{ 1.5 }
        end
        
      end
    end
  end
end
