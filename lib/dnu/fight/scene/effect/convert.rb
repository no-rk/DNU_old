# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Convert < BaseEffect
        
        def play_children
          battle_value    = @tree[:battle_value]
          sign            = @tree[:minus] ? -1 : 1
          calcu_tree      = @tree[:change_to]
          
          # battle_valueをcalcu_treeの計算値分だけ変化させる
          state_change!(battle_value, calcu_tree, [battle_value]) do |s,c|
            対象.send(s).change_to(sign*c)
          end
          
        end
        
      end
      class NextConvertVal < BaseEffect
        
        def play_children
          
          sign = @tree[:minus] ?   -1  :  1
          ant  = @tree[:ant]   ? 'Ant' : ''
          coeff_tree  = @tree[:coeff_value]
          change_tree = @tree[:change_value]
          
          next_effect_change!(sign, ant, coeff_tree, change_tree)
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
