module DNU
  module Fight
    module Scene
      class Effect < BaseScene
        
        def bt(effect_name)
          I18n.backend.send(:translations)[:ja][:DNU][:Fight][:Scene].invert[effect_name.to_s].try(:to_sym)
        end
        
        def create_children
          @tree = { bt(@tree.delete(:effect_name)) => @tree }
          super
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
