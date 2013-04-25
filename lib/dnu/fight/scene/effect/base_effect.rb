# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseEffect < BaseScene
        include Calculate
        
        def before_each_scene
          # 各効果種の対象が変化するかもしれない
          if @active.call.next_target?
            next_target = @active.call.next_target!
            @passive = lambda{ next_target }
          end
        end
        
        def create_change_value(calcu_tree)
          @create_change_value ||= lambda{ calcu_value(calcu_tree).call.to_i }
        end
        
        def state_change!(battle_value, calcu_tree, timings=[])
          change_value = create_change_value(calcu_tree).call
          history[:children] = { :battle_value => battle_value, :just_after => just_after(change_value) }
          
          # 変化量決定前
          ["",timings].flatten.each do |timing|
            play_(:before, :before, :"#{timing.to_s.underscore.camelize}#{scene_name}Val")
          end
          
          change_value = next_change!(change_value)
          
          before_change = 対象.send(battle_value).to_i
          yield(battle_value, change_value)
          after_change  = 対象.send(battle_value).to_i
          
          history[:children] = { :battle_value => battle_value, :change_value => change_value, :before_change => before_change, :after_change => after_change }
          
          # 変化量決定後
          ["",timings].flatten.each do |timing|
            play_(:after, :after, :"#{timing.to_s.underscore.camelize}#{scene_name}Val")
          end
          
        end
        
        def just_after(val)
          nexts = "#{scene_name}Val".underscore
          
          lambda do
            r = val
            r = 自分.send("next_#{nexts}").call(r)     if 自分.send("next_#{nexts}?")
            r = 対象.send("next_#{nexts}_ant").call(r) if 対象.send("next_#{nexts}_ant?")
            r
          end
        end
        
        def next_change!(val)
          nexts = "#{scene_name}Val".underscore
          
          r = val
          r = 自分.send("next_#{nexts}!").call(r)     if 自分.send("next_#{nexts}?")
          r = 対象.send("next_#{nexts}_ant!").call(r) if 対象.send("next_#{nexts}_ant?")
          r
        end
        
        def next_effect_change!(sign, ant, coeff_tree, change_tree)
          nexts = "#{scene_name}#{ant}".underscore
          
          next_val = 対象.send("#{nexts}!") || lambda{ |c_v| c_v.to_i }
          
          coeff  = coeff_tree  ? calcu_value(coeff_tree ).call.to_i : 0
          change = change_tree ? calcu_value(change_tree).call.to_i : 0
          la = lambda do |c_v|
            val = next_val.call(c_v)*(100 + sign*coeff)*0.01 + sign*change
            val > 0 ? val.to_i : 0
          end
          対象.send("#{nexts}=", la)
          
          history[:children] = { :sign => sign, :ant => ant, :coeff => coeff, :change => change }
          
        end
        
      end
    end
  end
end
