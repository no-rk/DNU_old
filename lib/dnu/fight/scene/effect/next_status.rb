# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextStatus < BaseEffect
        
        def play_children
          
          state_target    =(@tree[:state_target] || "対象").to_s
          status_name     = @tree[:status_name].to_s
          status_or_equip = @tree[:equip].nil? ? :status : :equip
          calcu_tree      = @tree[:change_to]
          
          change_to = calcu_value(calcu_tree).call.to_i
          
          # 対象の次のステータスを変化
          send(state_target).send(status_name).send("#{status_or_equip}_next=", change_to)
          
          history[:children] = { :state_target => send(state_target).name, :status_name => status_name, :change_to => change_to }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
