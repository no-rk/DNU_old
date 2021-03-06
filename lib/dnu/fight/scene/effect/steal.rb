# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Steal < BaseEffect
        
        def play_children
          
          status_name     = @tree[:status_name]
          status_or_equip = @tree[:equip].nil? ? :status : :equip
          calcu_tree      = @tree[:change_value]
          
          # status_nameをcalcu_treeの計算値分だけ変化させる
          state_change!(status_name, status_or_equip, calcu_tree, [status_name]) do |s,t,c|
            対象.send(s).send(t).change_value(-c)
            自分.send(s).send(t).change_value( c)
          end
          
        end
        
      end
      class NextStealVal < BaseEffect
        
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
