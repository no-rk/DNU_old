# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class CostDown < BaseEffect
        include Calculate
        
        def when_initialize
          @change = nil
        end
        
        def create_change
          @change ||= lambda{ calcu_value(@tree[:change_value]).call.to_i }
        end
        
        def play_children
          skill_name = @tree[:name]
          change  =-(@change || create_change).call
          success = false
          
          対象.effects.type(:Skill).find_by_name(skill_name).each do |e|
            e.cost.change_value(change)
            success = true
          end
          
          history[:children] = { :change => change, :skill_name => skill_name, :success => success }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
