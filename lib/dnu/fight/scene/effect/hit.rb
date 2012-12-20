# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Hit < BaseScene
        include Damage
        
        def when_initialize
          @damage = nil
        end
        
        def first_name
          @tree[child_name(@tree)][:element]
        end
        
        def middle_name
          :'属性'
        end
        
        def last_name
          I18n.t(child_name(@tree).to_s.camelize, :scope => "DNU.Fight.Scene")
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
