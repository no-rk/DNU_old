# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Attack < BaseScene
        
        def first_name
          @tree[:attack_type][child_name(@tree[:attack_type])][:element].keys.first
        end
        
        def last_name
          child_name(@tree[:attack_type]).to_s.camelize
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play
          self.each do |scene|
            log_before_each_scene
            play_(:before)
            play_(:before, :before, :"#{first_name}#{scene_name}")
            last_name.to_s.underscore.split("_").map{|p_or_m| p_or_m.camelize.to_sym }.each do |p_or_m|
              play_(:before, :before, :"#{p_or_m}#{scene_name}")
              play_(:before, :before, :"#{first_name}#{p_or_m}#{scene_name}")
            end
            play_(:before, :before, :Critical) if @tree.values.first[:critical]
            interrupt_before_play
            play_children
            play_(:after, :after, :Critical) if @tree.values.first[:critical]
            last_name.to_s.underscore.split("_").map{|p_or_m| p_or_m.camelize.to_sym }.each do |p_or_m|
              play_(:after, :after, :"#{first_name}#{p_or_m}#{scene_name}")
              play_(:after, :after, :"#{p_or_m}#{scene_name}")
            end
            play_(:after, :after, :"#{first_name}#{scene_name}")
            play_(:after)
          end
          @history.extend Html
        end
        
      end
    end
  end
end
