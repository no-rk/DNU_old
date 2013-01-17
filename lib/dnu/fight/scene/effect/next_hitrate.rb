# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextHitrate < BaseEffect
        include Calculate
        
        def play_children
          
          sign     = @tree[:minus] ? -1 : 1
          ant      = @tree[:ant] ? '_ant' : ''
          
          next_hitrate = 対象.send("next_hitrate#{ant}!") || lambda{ |c_v| c_v.to_i }
          
          coeff  = @tree[:coeff_value]  ? calcu_value(@tree[:coeff_value] ).call.to_i : 0
          change = @tree[:change_value] ? calcu_value(@tree[:change_value]).call.to_i : 0
          if @tree[:ant]
            la = lambda do |c_v|
              hit = (100-next_hitrate.call(c_v))*(100 + sign*coeff)*0.01 + sign*change
              hit = hit > 0 ? hit.to_i : 0
              hit >100 ? 100 : hit.to_i
              100 - hit
            end
          else
            la = lambda do |c_v|
              hit = next_hitrate.call(c_v)*(100 + sign*coeff)*0.01 + sign*change
              hit = hit > 0 ? hit.to_i : 0
              hit >100 ? 100 : hit.to_i
            end
          end
          対象.send("next_hitrate#{ant}=", la)
          history[:children] = { :sign => sign, :ant => ant, :coeff => coeff, :change => change }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
