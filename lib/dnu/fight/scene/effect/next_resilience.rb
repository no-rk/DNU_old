# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextResilience < BaseEffect
        include Calculate
        
        def play_children
          
          sign = @tree[:minus] ? -1 : 1
          ant  = @tree[:ant] ? '_ant' : ''
          
          next_resilience = 対象.send("next_resilience#{ant}!") || lambda{ |c_v| c_v.to_i }
          
          coeff  = @tree[:coeff_value]  ? calcu_value(@tree[:coeff_value] ).call.to_i : 0
          change = @tree[:change_value] ? calcu_value(@tree[:change_value]).call.to_i : 0
          la = lambda do |c_v|
            dmg = next_resilience.call(c_v)*(100 + sign*coeff)*0.01 + sign*change
            dmg > 0 ? dmg.to_i : 0
          end
          対象.send("next_resilience#{ant}=", la)
          
          history[:children] = { :sign => sign, :ant => ant, :coeff => coeff, :change => change }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
