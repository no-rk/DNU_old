# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Reduce < BaseEffect
        
        def play_children
          disease_name = @tree[:disease]
          calcu_tree   = @tree[:change_value]
          
          # status_nameをcalcu_treeの計算値分だけ変化させる
          state_change!(disease_name, calcu_tree, [disease_name]) do |s,c|
            対象.send(s).change_value(-c)
          end
          
        end
        
      end
      class NextReduceVal < BaseEffect
        
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
