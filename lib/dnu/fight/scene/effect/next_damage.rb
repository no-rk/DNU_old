# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextDamage < BaseEffect
        include Calculate
        
        def play_children
          
          sign = @tree[:minus] ? -1 : 1
          ant  = @tree[:ant] ? '_ant' : ''
          
          next_damage = 対象.send("next_damage#{ant}") || lambda{ |c_v| c_v.to_i }
          
          coeff  = @tree[:coeff_value]  ? calcu_value(@tree[:coeff_value] ).call.to_i : 1
          change = @tree[:change_value] ? calcu_value(@tree[:change_value]).call.to_i : 0
          la = lambda do |c_v|
            dmg = next_damage.call(c_v)*(100 + sign*coeff)*0.01 + sign*change
            dmg > 0 ? dmg.to_i : 0
          end
          対象.send("next_damage#{ant}=", la)
          
          history[:children] = { :sign => sign, :ant => ant, :coeff => coeff, :change => change }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
