# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Miss < BaseScene
        
        def first_name
          @tree[child_name(@tree)][:element].values.first
        end
        
        def middle_name
          :'属性'
        end
        
        def last_name
          I18n.t(child_name(@tree).to_s.camelize, :scope => "DNU.Fight.Scene")
        end
        
        def play_children
          history[:children] = { :element => first_name, :attack_type => last_name }
        end
        
      end
    end
  end
end
