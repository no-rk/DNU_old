# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Attack < BaseScene
        
        def first_name
          @tree[:attack_type][child_name(@tree[:attack_type])][:element]
        end
        
        def middle_name
          "Element"
        end
        
        def last_name
          child_name(@tree[:attack_type]).to_s.camelize
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
      end
    end
  end
end
