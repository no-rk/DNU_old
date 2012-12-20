# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Damage
        @@min_damage = 10
        
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
        
        def damage(tree)
          attack_type = tree.keys.first
          lambda do
            dmg  = try('dmg_' + attack_type.to_s).call
            dmg  = (dmg >= @@min_damage) ? dmg : @@min_damage
            logger(:dmg => dmg)
            dmg += rand(10)
            dmg  = dmg*tree[attack_type][:coeff_A].to_f + tree[attack_type][:coeff_B].to_f
            dmg *= dmg_element.call
            dmg.to_i
          end
        end
        
      end
    end
  end
end
