# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextDepth < BaseEffect
        include Calculate
        
        def play_children
          
          sign = @tree[:minus] ? -1 : 1
          ant  = @tree[:ant] ? '_ant' : ''
          
          next_depth = 対象.send("next_depth#{ant}!") || lambda{ |c_v| c_v.to_i }
          
          coeff  = @tree[:coeff_value]  ? calcu_value(@tree[:coeff_value] ).call.to_i : 0
          change = @tree[:change_value] ? calcu_value(@tree[:change_value]).call.to_i : 0
          la = lambda do |c_v|
            depth = next_depth.call(c_v)*(100 + sign*coeff)*0.01 + sign*change
            depth > 0 ? depth.to_i : 0
          end
          対象.send("next_depth#{ant}=", la)
          
          history[:children] = { :sign => sign, :ant => ant, :coeff => coeff, :change => change }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
