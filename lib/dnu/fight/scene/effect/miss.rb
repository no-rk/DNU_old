# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Miss < BaseScene
        
        def first_name
          @tree[:element]
        end
        
        def middle_name
          "Element"
        end
        
        def last_name
          child_name(@tree[:attack_type]).to_s.camelize
        end
        
        def play_children
          history[:children] << "回避した！"
        end
        
      end
    end
  end
end
