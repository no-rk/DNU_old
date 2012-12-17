# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Attack < BaseScene
        
        def first_name
          @tree[:element]
        end
        
        def middle_name
          "Element"
        end
        
        def last_name
          child_name(@tree[:attack_type]).to_s.camelize
        end
        
        def scene_name
          [first_name, middle_name, last_name, self_name]
        end
        
        def human_name
          [
            first_name + I18n.t(middle_name, :scope => "DNU.Fight.Scene"),
            I18n.t(last_name, :scope => "DNU.Fight.Scene"),
            I18n.t(self_name, :scope => "DNU.Fight.Scene")
          ]
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
      end
    end
  end
end
