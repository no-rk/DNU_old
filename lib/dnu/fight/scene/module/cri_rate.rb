# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module CriRate
        
        def 自分
          @active.call
        end
        
        def 対象
          @passive.try(:call) || @active.call
        end
        
        def cri_physical
          lambda{ 自分.CRI.to_f/(自分.CRI.to_f + 対象.SPD.to_f) }
        end
        
        def cri_magical
          lambda{ 自分.CRI.to_f/(自分.CRI.to_f + 対象.SPD.to_f) }
        end
        
        def cri_physical_magical
          lambda{ (cri_physical.call + cri_magical.call)/2.to_f }
        end
        
        def cri_element
          lambda{ 1.to_f }
        end
        
      end
    end
  end
end
