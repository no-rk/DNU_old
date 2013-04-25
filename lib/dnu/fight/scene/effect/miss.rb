# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Miss < BaseEffect
        
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
          history[:children] = { :attack_element => attack_element, :attack_type => attack_type }
        end
        
        def play
          
          self.each do |scene|
            ["",attacks].flatten.each do |timing|
              play_(:before, :before, :"#{timing.to_s.underscore.camelize}#{scene_name}")
            end
            play_children
            ["",attacks].flatten.each do |timing|
              play_(:after, :after, :"#{timing.to_s.underscore.camelize}#{scene_name}")
            end
          end
          
          @history.extend Html
          
        end
        
      end
    end
  end
end
