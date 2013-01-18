# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Heal < BaseEffect
        
        def play_children
          
          status_name = @tree[:status_name].to_s
          calcu_tree  = @tree[:change_value]
          
          # status_nameをcalcu_treeの計算値分だけ変化させる
          state_change!(status_name, calcu_tree, [status_name]) do |s,c|
            対象.send(s).change_value(c)
          end
          
        end
        
      end
      class NextHealVal < BaseEffect
        
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
