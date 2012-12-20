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
          damage(@tree)
        end
        
        def play_children
          history[:children] << "#{(@damage || create_damage).call}の#{first_name}#{middle_name}#{last_name}ダメージを受けた！"
        end
        
      end
    end
  end
end
