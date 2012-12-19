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
        
        def physical(tree)
          dmg = 自分.AT - 対象.DF.to_f/2 + rand(10)
          dmg = 10 if dmg < 10
          dmg*tree[:coeff_A].to_f + tree[:coeff_B].to_f
        end
        
        def magical(tree)
          dmg = 自分.MAT - 対象.MDF.to_f/2 + rand(10)
          dmg = 10 if dmg < 10
          dmg*tree[:coeff_A].to_f + tree[:coeff_B].to_f
        end
        
        def element(tree)
          1.to_f
        end
        
        def damage(tree)
          attack_type = tree[:attack_type].keys.first
          (try(attack_type, tree[:attack_type][attack_type])*element(tree[:element])).to_i
        end
        
      end
    end
  end
end
