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
          @tree[child_name(@tree)][:element].values.first
        end
        
        def middle_name
          :'属性'
        end
        
        def last_name
          I18n.t(child_name(@tree).to_s.camelize, :scope => "DNU.Fight.Scene")
        end
        
        def damage(tree)
          attack_type = tree.keys.first
          if tree[attack_type][:coeff_value]
            lambda do
              dmg  = try('dmg_' + attack_type.to_s).call
              dmg  = (dmg >= @@min_damage) ? dmg : @@min_damage
              logger(:dmg => dmg)
              dmg  = dmg*calcu_value(tree[attack_type][:coeff_value]).call
              dmg *= dmg_element.call
              dmg.to_i
            end
          elsif tree[attack_type][:change_value]
            lambda{ (calcu_value(tree[attack_type][:change_value]).call*dmg_element.call).to_i }
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
          
          history[:children] = { :element => first_name, :attack_type => last_name, :before_change => before_change, :after_change => after_change }
          logger({ :element => first_name, :attack_type => last_name, :before_change => before_change, :after_change => after_change })
        end
        
      end
    end
  end
end
