# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Attack < BaseEffect
        
        def attack_element
          @data.values.first[:element].keys.first.to_s.camelize
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
            
            [attacks].flatten.each do |timing|
              play_(:before, :before, :"#{timing.to_s.underscore.camelize}#{scene_name}")
            end
            
            # 攻撃対象変化があった場合は適用。
            if 自分.next_attack_target?
              next_attack_target = 自分.next_attack_target!
              @passive = lambda{ next_attack_target }
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
