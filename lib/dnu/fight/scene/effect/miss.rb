# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Miss < BaseEffect
        
        def element_name
          @data.values.first[:element].keys.first
        end
        
        def attack_type_name
          child_name(@data).to_s.camelize
        end
        
        def play_children
          history[:children] = { :element => element_name, :attack_type => attack_type_name }
        end
        
        def play
          self.each do |scene|
            play_(:before)
            play_(:before, :before, :"#{element_name}#{scene_name}")
            attack_type_name.to_s.underscore.split("_").map{|p_or_m| p_or_m.camelize.to_sym }.each do |p_or_m|
              play_(:before, :before, :"#{p_or_m}#{scene_name}")
              play_(:before, :before, :"#{element_name}#{p_or_m}#{scene_name}")
            end
            play_children
            attack_type_name.to_s.underscore.split("_").map{|p_or_m| p_or_m.camelize.to_sym }.each do |p_or_m|
              play_(:after, :after, :"#{element_name}#{p_or_m}#{scene_name}")
              play_(:after, :after, :"#{p_or_m}#{scene_name}")
            end
            play_(:after, :after, :"#{element_name}#{scene_name}")
            play_(:after)
          end
          @history.extend Html
        end
        
      end
    end
  end
end
