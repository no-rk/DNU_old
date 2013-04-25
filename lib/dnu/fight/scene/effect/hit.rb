# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Hit < BaseEffect
        
        def attack_element
          @data.values.first[:element]
        end
        
        def attack_type
          child_name(@data).to_s.camelize
        end
        
        def attack_types
          child_name(@data).to_s.underscore.split("_").map{ |p_or_m| p_or_m.camelize }
        end
        
        def attack_element_and_types
          [attack_element].product(attack_types).map{ |a| a.join }
        end
        
        def attacks
          [attack_element, attack_types, attack_element_and_types].flatten
        end
        
        def play_children
          
          critical = @tree[:critical]
          coeff_tree  = @data.values.first[:coeff_value]
          change_tree = @data.values.first[:change_value]
          
          # 係数ダメージか固定ダメージかで場合わけ
          if coeff_tree
            calcu_tree = {
              :multi_coeff => [
                coeff_tree,
                { :condition_damage => "#{attack_type.underscore}!" }
              ]
            }
          elsif change_tree
            calcu_tree = change_tree
          else
            raise @data.to_s
          end
          
          state_change!(:HP, calcu_tree, attacks) do |s,c|
            対象.send(s).change_value(-c)
          end
          
          history[:children].merge!(:critical => critical, :attack_element => attack_element, :attack_type => attack_type)
          
        end
        
        def play
          
          self.each do |scene|
            ["",attacks].flatten.each do |timing|
              play_(:before, :before, :"#{timing.to_s.underscore.camelize}#{scene_name}")
            end
            ["",attacks].flatten.each do |timing|
              play_(:before, :before, :"#{timing.to_s.underscore.camelize}Critical")
            end if @tree[:critical]
            play_children
            ["",attacks].flatten.each do |timing|
              play_(:after, :after, :"#{timing.to_s.underscore.camelize}Critical")
            end if @tree[:critical]
            ["",attacks].flatten.each do |timing|
              play_(:after, :after, :"#{timing.to_s.underscore.camelize}#{scene_name}")
            end
          end
          
          @history.extend Html
          
        end
        
      end
      class NextHitVal < BaseEffect
        
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
