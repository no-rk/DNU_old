# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Cost < BaseEffect
        
        def play_children
          calcu_tree = @tree[:change_value]
          
          # MPをcalcu_treeの計算値分だけ変化させる
          state_change!(:MP, calcu_tree) do |s,c|
            対象.send(s).change_value(-c)
          end
          
        end
        
      end
      class NextCostVal < BaseEffect
        
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
