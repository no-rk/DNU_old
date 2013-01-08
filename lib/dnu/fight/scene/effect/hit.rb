# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Hit < BaseScene
        include Calculate
        
        @@min_damage = 10
        
        def when_initialize
          @damage = nil
        end
        
        def first_name
          @tree[child_name(@tree)][:element].keys.first
        end
        
        def last_name
          child_name(@tree).to_s.camelize
        end
        
        def damage(tree)
          attack_type = tree.keys.first
          if tree[attack_type][:coeff_value]
            lambda do
              dmg  = try('dmg_' + attack_type.to_s).call
              dmg  = (dmg >= @@min_damage) ? dmg : @@min_damage
              logger(:dmg => dmg)
              dmg *= calcu_value(tree[attack_type][:coeff_value]).call
              dmg *= dmg_element.call
              dmg *= dmg_critical.call if tree[attack_type][:critical]
              dmg.to_i
            end
          elsif tree[attack_type][:change_value]
            lambda do
              dmg  = calcu_value(tree[attack_type][:change_value]).call
              dmg *= dmg_element.call
              dmg *= dmg_critical.call if tree[attack_type][:critical]
              dmg.to_i
            end
          else
            raise tree.to_s
          end
        end
        
        def create_damage
          @damage ||= damage(@tree)
        end
        
        def play_children
          damage = (@damage || create_damage).call
          
          before_change = 対象.HP.val
          対象.HP.change_value(-damage)
          after_change  = 対象.HP.val
          
          history[:children] = { :critical => @tree.values.first[:critical], :element => first_name, :attack_type => last_name, :before_change => before_change, :after_change => after_change }
          logger({ :element => first_name, :attack_type => last_name, :before_change => before_change, :after_change => after_change })
        end
        
        def play
          self.each do |scene|
            play_(:before)
            play_(:before, :before, :"#{first_name}#{scene_name}")
            last_name.to_s.underscore.split("_").map{|p_or_m| p_or_m.camelize.to_sym }.each do |p_or_m|
              play_(:before, :before, :"#{p_or_m}#{scene_name}")
              play_(:before, :before, :"#{first_name}#{p_or_m}#{scene_name}")
            end
            play_(:before, :before, :Critical) if @tree.values.first[:critical]
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
