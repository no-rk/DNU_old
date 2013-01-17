# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Attack < BaseEffect
        include Calculate
        
        def element_name
          @data.values.first[:element].keys.first
        end
        
        def attack_type_name
          child_name(@data).to_s.camelize
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play
          self.each do |scene|
            play_(:before)
            # 攻撃前に属性と攻撃種を決定する。
            @data = Marshal.load(Marshal.dump(@tree[:attack_type]))
            @data.values.first[:element] = 自分.next_attack_element! if 自分.next_attack_element?
            @data = { 自分.next_attack_type! => @data.values.first } if 自分.next_attack_type?
            # 攻撃対象変化があった場合は適用。
            if 自分.next_attack_target?
              next_attack_target = 自分.next_attack_target!
              @passive = lambda{ next_attack_target }
            end
            
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
