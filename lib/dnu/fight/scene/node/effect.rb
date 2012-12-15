module DNU
  module Fight
    module Scene
      class Effect < BaseScene
        
        def bt(effect_name)
          I18n.backend.send(:translations)[:ja][:DNU][:Fight][:Scene].invert[effect_name.to_s].try(:to_sym)
        end
        
        def after_each_scene
          @label[:each_effect].try(:each) do |h|
            if rand(100)<50
              #p "++++++++++++++++++++++++"
              #p "jump to #{h.keys.first}"
              #p "++++++++++++++++++++++++"
              throw h.keys.first
            end
          end
        end
        
        def before_create_children
          @tree = { bt(@tree.delete(:effect_name)) => @tree }
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
